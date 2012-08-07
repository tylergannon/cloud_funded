OmniAuth.config.mock_auth[:facebook] = YAML::load_file File.join(Rails.root, 'spec', 'support', 'facebook_tyler.yml')
OmniAuth.config.mock_auth[:dwolla] = YAML::load_file File.join(Rails.root, 'spec', 'support', 'dwolla_tyler.yml')
OmniAuth.config.mock_auth[:twitter] = YAML::load_file File.join(Rails.root, 'spec', 'support', 'twitter_tyler.yml')
