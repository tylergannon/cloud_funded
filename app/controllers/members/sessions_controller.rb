class Members::SessionsController < Devise::SessionsController
  after_filter CloudFunded::Twitter::SetTwitterIdFilter, only: :create
end
