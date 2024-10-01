require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:6379" }
  Sidekiq.default_job_options = { 'retry' => 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:6379" }
end
