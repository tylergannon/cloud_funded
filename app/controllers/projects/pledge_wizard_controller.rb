class Projects::PledgeWizardController < ApplicationController
  include Wicked::Wizard
  
  steps :pledge, :choose_payment_method, :pay_by_cc, :share

  before_filter :authenticate_member!, :load_project, :redirect_as_needed
  
  def show
    authorize! :edit, @pledge
    render_wizard
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
  
  def submit_pledge
    if @pledge.valid?
      @pledge.pledge!
    end
    render_wizard(@pledge)
  end
  
  def submit_choose_payment_method
    if @pledge.valid?
      @pledge.choose_pay_by_cc!
    end
    render_wizard(@pledge)
  end
  
  def submit_pay_by_cc
    token = params[:stripe_token]
    puts "*" * 100
    puts token
  
    # create the charge on Stripe's servers - this will charge the user's card
    @charge = Stripe::Charge.create(
      :amount => @pledge.amount * 100, # amount in cents, again
      :currency => "usd",
      :card => token,
      :description => "CloudFunded pledge to #{@project.name}"
    )
    @stripe_transaction = StripeTransaction.from_stripe_charge(@charge)
    @stripe_transaction.member = current_member
    @stripe_transaction.pledge = @pledge
    @stripe_transaction.save!
    render_wizard(@pledge)
  end
  
  
  def load_project
    @project = params[:project_id] ? 
                  Project.find(params[:project_id]) : 
                  current_member.project_application
    pledges = Pledge.where(project_id: @project.id, investor_id: current_member.id)
    @pledge = pledges.empty? ? pledges.create! : pledges.first
  end
  
  def redirect_as_needed
    if @pledge.not_pledged?
      if step != :pledge
        redirect_to new_project_pledge_path(@project)
      end
    elsif @pledge.workflow_state != step.to_s
      redirect_to new_project_pledge_path(@project, @pledge.workflow_state)
    end
  end
end
