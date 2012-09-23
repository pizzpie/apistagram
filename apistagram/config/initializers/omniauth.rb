Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, AppConfiguration['instagram_client_id'], AppConfiguration['instagram_client_secret']
end