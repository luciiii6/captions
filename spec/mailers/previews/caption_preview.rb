# Preview all emails at http://localhost:3000/rails/mailers/caption
class CaptionPreview < ActionMailer::Preview
  def captions_saved_mail
    CaptionMailer.with({}).captions_saved_mail
  end
end
