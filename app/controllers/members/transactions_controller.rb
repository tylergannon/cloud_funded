class Members::TransactionsController < ApplicationController
  before_filter :authenticate_member!, :load_member
  def new
    session[:return_after_dwolla_login] = new_account_fund_path
    @transaction = @member.transactions.build
  end
  
  def create
    amount = params[:amount].to_f
    pin = params[:pin].to_i
    @transaction = @member.transactions.build
    
    begin
      user = Dwolla::User.me(@member.dwolla_auth_token)
      transaction_id = user.send_money_to("812-608-2017", amount, pin, 'dwolla', 'Funding Account')
      @transaction.attributes = {amount: amount, 
                                 transaction_id: transaction_id,
                                 source: 'dwolla',
                                 status: 'complete'}
      @transaction.save
    rescue Dwolla::RequestException => e
      if e.message == "Invalid account PIN"
        flash[:error] = 'Check your data -- Try a better PIN number.'
      elsif e.message == "Insufficient funds."
        flash[:error] = "Insufficient funds."
      elsif e.message.match(/Amount must be at least/)
        flash[:error] = "Amount must be at least $0.01"
      elsif e.message.match(/Invalid access token/)
        flash[:error] = "Hmmm, we were unable to access your account.  Did you deauthorize the app?  You'll need to re-enable it."
        @member.update_attributes dwolla_auth_token: nil
      else
        raise e
      end
    rescue Dwolla::Response::AccessDeniedError => e
      flash[:error] = "Hmmm, we were unable to access your account.  Did you deauthorize the app?  You'll need to re-enable it."
      @member.transactions -= [@transaction]
      @member.update_attributes dwolla_auth_token: nil
    rescue Exception => e
      # puts "*" + e.message + "*"
      raise e
    end
    
    respond_with @transaction do |format|
      format.html {
        if @transaction.persisted?
          flash[:notice] = 'Congratulations, you\'re rich!'
          redirect_to account_path
        else
          flash[:error] ||= "There was an error!  Damn." + @transaction.errors.inspect
          render action: 'new'
        end
      }
    end
  end
  
  def load_member
    @member = current_member
  end
  
end