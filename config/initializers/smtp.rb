
CloudFunded::Application.configure do
  config.action_mailer.default :charset => "utf-8"
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'cloudfunded.com'
  }
  ActionMailer::Base.delivery_method = :smtp
end
