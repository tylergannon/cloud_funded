class Members::ConfirmationsController < Devise::ConfirmationsController
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
    else
      flash[:notice] = 'you did not do it right'
      respond_with(resource)
    end
  end
end