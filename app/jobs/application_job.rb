# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include SuckerPunch::Job
end
