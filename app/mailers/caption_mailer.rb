class CaptionMailer < ApplicationMailer

  def captions_saved_mail
    mail(to: 'luci.suvaila@gmail.com', subject: 'Caption saved succesfully')
  end
end
