Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, AppConfiguration['cakesta']['instagram_client_id'], AppConfiguration['cakesta']['instagram_client_secret']
end