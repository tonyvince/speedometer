require 'pony'

class Mailer
  attr_reader :download_rate, :upload_rate, :latency

  def initialize(download_rate, upload_rate, latency)
    @download_rate = download_rate
    @upload_rate = upload_rate
    @latency = latency
  end

  def send_mail
    to = CONFIG['settings']['email_to']
    from = CONFIG['settings']['email_to']

    subject = I18n.t('email.subject')
    body = I18n.t('email.body', download_rate: download_rate,
                  upload_rate: upload_rate, latency: latency)

    Pony.mail(to: to, from: from, subject: subject, body: body)
  end
end
