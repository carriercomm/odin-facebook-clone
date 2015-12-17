class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include UsersHelper

    before_filter :configure_permitted_parameters, if: :devise_controller?

    def store_location
		session[:return_to] ||= request.referrer    	
    end

    def return_back_or_to_default default_url = root_url
      return_url = session[:return_to]
      if return_url
        session[:return_to] = nil      
  			redirect_to return_url

  	  else
  			redirect_to default_url
      end	
    end

    def check_if_owner_is_current_user(affected_class)
      affected_item = affected_class.find(params[:id])
      owner = User.find_by(id: affected_item.user.id)
      redirect_to root_path unless owner == current_user
    end

    protected

        def configure_permitted_parameters
            devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
            devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :id, :password_confirmation, :current_password, bio_attributes:[:description]) }
        end


end
