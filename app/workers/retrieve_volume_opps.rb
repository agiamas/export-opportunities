class RetrieveVolumeOpps
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform
    editor = Editor.where(email: Figaro.env.MAILER_FROM_ADDRESS!).first
    today_date = Time.zone.now.strftime('%Y-%m-%d')
    VolumeOppsRetriever.new.call(editor, today_date)
  end
end
