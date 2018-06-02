# frozen_string_literal: true

class Groups::TopicsController < ApplicationController
  after_action :verify_authorized

  def index
    @group  = find_group
    @topics = find_all_topics

    authorize :topic

    add_breadcrumbs_for_index
  end

  def show
    @group    = find_group
    @topic    = find_topic
    @comments = find_comments
    @comment  = TopicComment.new

    authorize @topic

    add_breadcrumbs_for_show
  end

  def new
    @group = find_group
    @topic = Topic.new

    authorize @topic

    add_breadcrumbs_for_topic_creation
  end

  def edit
    @group = find_group
    @topic = find_topic

    authorize @topic

    add_breadcrumbs_for_topic_edition
  end

  def create
    @group = find_group
    @topic = create_topic

    authorize @topic

    add_breadcrumbs_for_topic_creation

    if @topic.save
      flash[:success] = "New topic created."
      redirect_to group_topic_path(@group, @topic)
    else
      render :new
    end
  end

  def update
    @group = find_group
    @topic = find_topic

    authorize @topic

    add_breadcrumbs_for_topic_edition

    if topic_update_attributes
      flash[:success] = "Topic updated."
      redirect_to group_topic_path(@group, @topic)
    else
      render :edit
    end
  end

  def destroy
    @group = find_group
    @topic = find_topic

    authorize @topic

    @topic.destroy

    flash[:success] = "Topic deleted."
    redirect_to group_topics_path(@group)
  end

  private

    def find_group
      Group.find(params[:group_id])
    end

    def find_all_topics
      Topic.all
           .includes(:user)
           .order(updated_at: :desc)
           .paginate(page: params[:page], per_page: 25)
    end

    def find_topic
      Topic.find(params[:id])
    end

    def find_comments
      @topic.comments
    end

    def create_topic
      @group.topics.new(topic_params.merge(user: current_user))
    end

    def topic_update_attributes
      @topic.update_attributes(topic_params)
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

    def topic_params
      params.require(:topic).permit(:title, :body)
    end
end
