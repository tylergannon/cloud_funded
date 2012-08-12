class Projects::PledgeWizardController < ApplicationController
  include Wicked::Wizard
  layout 'pledge_wizard'
  
  steps :amount, :payment_method, :dwolla, :cc, :share

  before_filter :authenticate_member!, :load_project

  def finish_wizard_path
    project_my_pledge_path(@project)
  end
      
  def show
    if current_member.funded?(@project)
      redirect_to project_my_pledge_path(@project)
    else
      puts step.inspect + "\n*" * 10
      case step
      when :amount
        @breadcrumbs = [['Amount + Perks', :amount]]
      when :payment_method
        @breadcrumbs = [['Amount + Perks', :amount], ['Payment Method', :payment_method]]
      when :dwolla
        @breadcrumbs = [['Amount + Perks', :amount], ['Payment Method', :payment_method], ['Pay with Dwolla', :dwolla]]
        if current_member.linked_to_dwolla?
          @funding_sources = Dwolla::User.me(current_member.dwolla_auth_token).funding_sources.select{|f|
            f.verified
          }.map{|f|
            [f.name, f.id]
          }
          @funding_sources.unshift ['Dwolla Account', '']
        end
      when :cc
        @breadcrumbs = [['Amount + Perks', :amount], ['Payment Method', :payment_method], ['Pay with Credit Card', :cc]]
      end
    
      authorize! :edit, @pledge
      render_wizard
    end
  end
  
  def update
    authorize! :edit, @pledge
    if params[:pledge]
      @pledge.update_attributes params[:pledge]
    end
    if respond_to?("submit_#{step}")
      send "submit_#{step}"
    else
      render_wizard(@pledge)
    end
  end
  
  def submit_amount
    render_wizard(@pledge)
  end
  
  def submit_payment_method
    unless @pledge.valid?
      render_wizard(@pledge)
    else
      redirect_to wizard_path(@pledge.payment_method)
    end
  end
  
  def submit_cc
    begin
      token = params[:stripe_token]
      raise "blahblah" if token.blank?
      @charge = Stripe::Charge.create(
        :amount => @pledge.amount_cents, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => "CloudFunded pledge to #{@project.name}"
      )
      @stripe_transaction = StripeTransaction.from_stripe_charge(@charge)
      @stripe_transaction.member = current_member
      @stripe_transaction.pledge = @pledge
      @stripe_transaction.save!
      if @pledge.valid?
        @pledge.pay_by_cc!
      end
      render_wizard(@pledge)
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      # puts e.inspect
      render :cc
    rescue Exception => e
      flash[:alert] = e.message
      # puts e.inspect
      render :cc
    end
  end
  
  def load_project
    @project = params[:project_id] ? 
                  Project.find(params[:project_id]) : 
                  current_member.project_application
    pledges = Pledge.where(project_id: @project.id, investor_id: current_member.id)
    @pledge = pledges.empty? ? pledges.create! : pledges.first
  end
  
  # def redirect_as_needed
  #   unless params[:id]
  #     if step != WORKFLOW_STATE_WIZARD_STEP[@pledge.workflow_state]
  #       the_correct_step = WORKFLOW_STATE_WIZARD_STEP[@pledge.workflow_state]
  #       if the_correct_step == :pledge
  #         redirect_to new_project_pledge_path(@project)
  #       else
  #         redirect_to new_project_pledge_path(@project, the_correct_step)
  #       end
  #     end
  #   end
  # end
  
  WORKFLOW_STATE_WIZARD_STEP = {
    'new' => :amount,
    'not_pledged' => :amount,
    'choose_payment_method' => :payment_method,
    'pay_by_cc' => :pay_by_cc,
    'payment_received' => :share
  }
end
