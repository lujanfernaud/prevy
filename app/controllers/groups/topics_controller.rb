# frozen_string_literal: true

class Groups::TopicsController < ApplicationController
  include Groups::AuthorizationRedirecter

  before_action :find_group
  after_action  :verify_authorized, except: [:index, :show]

  def index
    @topics = find_all_topics

    add_breadcrumbs_for_index
  end

  def show
    @topic    = find_topic
    @comments = find_comments
    @comment  = TopicComment.new

    add_breadcrumbs_for_show
  end

  def new
    @topic = Topic.new

    authorize @topic

    add_breadcrumbs_for_topic_creation
  end

  def edit
    @topic = find_topic

    authorize @topic

    add_breadcrumbs_for_topic_edition
  end

  def create
    @topic = create_topic

    authorize @topic

    add_breadcrumbs_for_topic_creation

    if @topic.save
      flash_save
      redirect_to group_topic_path(@group, @topic)
    else
      render :new
    end
  end

  def update
    @topic = find_topic

    authorize @topic

    add_breadcrumbs_for_topic_edition

    if @topic.update_attributes(topic_params)
      flash_update
      redirect_to group_topic_path(@group, @topic)
    else
      render :edit
    end
  end

  def destroy
    @topic = find_topic

    authorize @topic

    @topic.destroy

    flash[:success] = "Topic deleted."
    redirect_to group_topics_path(@group)
  end

  private

    def find_group
      @group ||= Group.find(params[:group_id])
    end

    def find_all_topics
      @group.topics_prioritized.paginate(page: params[:page], per_page: 25)
    end

    def find_topic
      Topic.find(params[:id])
    end

    def find_comments
      @topic.comments.includes(:edited_by)
    end

    def create_topic
      @group.topics.new(topic_params_with_user)
    end

    def topic_params_with_user
      topic_params.merge(user: current_user)
    end

    def topic_params
      params.require(:topic)
            .permit(:title, :body, :type)
            .merge(edited_by: current_user)
    end

    def flash_save
      if @topic.announcement?
        flash[:success] = "New announcement topic created."
      elsif @topic.pinned?
        flash[:success] = "New pinned topic created."
      else
        flash[:success] = "New topic created."
      end
    end

    def flash_update
      if set_to_normal_topic?
        flash[:success] = "Topic set to normal topic."
      elsif set_to_pinned_topic?
        flash[:success] = "Topic set to pinned topic."
      else
        flash[:success] = "Topic updated."
      end
    end

    def set_to_normal_topic?
      return unless @topic.saved_changes.include?("type")

      @topic.normal?
    end

    def set_to_pinned_topic?
      return unless @topic.saved_changes.include?("type")

      @topic.pinned?
    end

    def add_breadcrumbs_for_index
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Topics"
    end

    def add_breadcrumbs_for_show
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Topics", group_topics_path(@group)
      add_breadcrumb @topic.title
    end

    def add_breadcrumbs_for_topic_creation
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Topics", group_topics_path(@group)
      add_breadcrumb "New topic"
    end

    def add_breadcrumbs_for_topic_edition
      add_breadcrumb @group.name, group_path(@group)
      add_breadcrumb "Topics", group_topics_path(@group)
      add_breadcrumb @topic.title, group_topic_path(@group, @topic)
      add_breadcrumb "Edit topic"
    end
end
