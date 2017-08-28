class ApplicationMailer < ActionMailer::Base
  default from: 'email@test.com'
  layout 'mailer'
end
