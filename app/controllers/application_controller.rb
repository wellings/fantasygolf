class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 before_action :authenticate_user!, :except => [:index]
 before_action :configure_permitted_parameters, if: :devise_controller?
 
 helper_method :tournament_locked?
 
 def tournament_locked?
  Tournament.where("active=1").first.locked
 end

 def tournament_locked
      if Tournament.where("active=1").first.locked?
	flash[:alert] = "Tournament has been locked down."
	redirect_to root_path # halts request cycle
      end
 end


 protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u| 
	    u.permit(:first_name, :last_name, :tiebreaker, :email, :password, :password_confirmation, :paid, :rank)
     end
    devise_parameter_sanitizer.for(:account_update) do |u| 
	    u.permit(:first_name, :last_name, :tiebreaker, :email, :password, :password_confirmation, :paid, :rank)
     end
  end
end
