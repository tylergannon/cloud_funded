class Admin::TransactionsController < ApplicationController
  before_filter :authenticate_member!, :authorize_admin
  
  def index
    @transactions = Transaction.all
    @pledges = Pledge.where(workflow_state: 'paid')
  end
  
  def authorize_admin
    authorize! :rule, :the_world
  end
end
