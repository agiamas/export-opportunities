require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: Figaro.env.redis_url! }
  schedule_file = 'config/sidekiq_schedule.yml'

  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: Figaro.env.redis_url! }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [Figaro.env.sidekiq_username!, Figaro.env.sidekiq_password!]
end
