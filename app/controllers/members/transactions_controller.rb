class Members::TransactionsController < ApplicationController
  before_filter :load_member
  respond_to :html, :js
  
  def new
    session[:return_after_dwolla_login] = new_account_fund_path
    @transaction = DwollaTransaction.new(member: @member)
    # @member.transactions << @transaction
  end
  
  def create
    amount       = params[:amount].to_f
    pin          = params[:pin].to_i
    funds_source = params[:funds_source].blank? ? nil : params[:funds_source]
    pledge_id    = params[:pledge_id]
    
    @transaction = DwollaTransaction.new(member: @member)
    
    begin
      user = Dwolla::User.me(@member.dwolla_auth_token)
      transaction_id = user.send_money_to("812-608-2017", amount, pin, 'dwolla', 'Funding Account', funds_source)
      @transaction.attributes = {amount: amount, 
                                 transaction_id: transaction_id,
                                 transaction_date: DateTime.now,
                                 pledge_id: params[:pledge_id],
                                 amount_refunded: 0,
                                 disputed: false,
                                 fee: (amount >= 10) ? 0 : 25,
                                 refunded: false,
                                 paid: true}
      @transaction.save
      if params[:pledge_id]
        @pledge = Pledge.find(params[:pledge_id])
        @pledge.pay_by_dwolla!
        @project = @pledge.project
      end
    rescue Dwolla::RequestException => e
      if e.message == "Invalid account PIN"
        flash[:alert] = 'Check your data -- Try a better PIN number.'
      elsif e.message == "Insufficient funds."
        flash[:alert] = "Insufficient funds."
      elsif e.message.match(/Amount must be at least/)
        flash[:alert] = "Amount must be at least $0.01"
      elsif e.message.match(/Invalid access token/)
        flash[:alert] = "Hmmm, we were unable to access your account.  Did you deauthorize the app?  You'll need to re-enable it."
        @member.update_attributes dwolla_auth_token: nil
      else
        raise e
      end
    rescue Dwolla::Response::AccessDeniedError => e
      flash[:alert] = "Hmmm, we were unable to access your account.  Did you deauthorize the app?  You'll need to re-enable it."
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
          flash[:alert] ||= "There was an error!  Damn." + @transaction.errors.inspect
          render action: 'new'
        end
      }
      format.js {
        if @transaction.persisted?
          flash[:notice] = 'Payment was successful.'
          render action: 'create', status: 200
        else
          flash[:alert] ||= "There was an error!  Damn." + @transaction.errors.inspect
          render action: 'create', status: 403
        end
      }
    end
  end
  
  def load_member
    @member = current_member
  end
end
