class ApplicationController < ActionController::Base
  responders :flash, :http_cache
  protect_from_forgery
end
