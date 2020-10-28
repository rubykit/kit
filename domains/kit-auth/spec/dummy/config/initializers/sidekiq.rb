Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_SIDEKIQ_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_SIDEKIQ_URL'] }
end

schedule_file = 'config/sidekiq_cron.yml'

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq::Extensions.enable_delay!
