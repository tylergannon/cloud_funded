class Admin::TestController < ApplicationController
  before_filter :authenticate_member!
  def index
    
  end
end
