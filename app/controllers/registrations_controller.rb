class RegistrationsController < Devise::RegistrationsController

respond_to :html, :json

def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)

    respond_to do |format|
	if @user.update_attributes(account_update_params)
	    format.html { 
		set_flash_message :notice, :updated
		# Sign in the user bypassing validation in case his password changed
		sign_in @user, :bypass => true
		redirect_to root_path
	    }
            format.json { respond_with_bip(@user) }
	else
            format.html { render "edit" }
            format.json { render :json => @user.errors.full_messages, :status => :unprocessable_entity }
	end
   end
end


end
