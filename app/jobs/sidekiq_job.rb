# frozen_string_literal: true

class SidekiqJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker
end
