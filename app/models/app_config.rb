class AppConfig
  def self.linkedin_api_key
    'hiw5aejarf2j'
  end
  
  def self.linkedin_secret_key
    'GGIqnEcOo7LYkcs8'
  end
  
  def self.opengraph_namespace
    ENV['OPENGRAPH_NAMESPACE']
  end
  
  def self.stripe_public_key
    ENV['STRIPE_PUBLISHABLE_KEY']
  end
end