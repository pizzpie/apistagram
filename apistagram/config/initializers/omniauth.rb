Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, 'f80ef60d36484219bbf57edde71f974a', '8f18438afd3e4cf39ac13d1a9dccfb46'
end