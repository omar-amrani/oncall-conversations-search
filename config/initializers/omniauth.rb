Rails.application.config.middleware.use OmniAuth::Builder do
  provider :intercom, ENV['INTERCOM_KEY'], ENV['INTERCOM_SECRET']
end