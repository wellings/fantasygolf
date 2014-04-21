class User::ParameterSanitizer < Devise::ParameterSanitizer
    private
    def account_update
        default_params.permit(:first_name, :last_name, :tiebreaker, :email, :password, :password_confirmation, :current_password)
    end
    def sign_up
        default_params.permit(:first_name, :last_name, :tiebreaker, :email, :password, :password_confirmation, :current_password)
    end

end

