# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "luci.suvaila@gmail.com"
  layout "mailer"
end
