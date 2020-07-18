Rails.application.config.generators do |g|
  g.helper false
  g.assets false
  g.test_framework :rspec,
                   request_specs: false,
                   controller_specs: true,
                   view_specs: false,
                   routing_specs: false,
                   helper_specs: false
end