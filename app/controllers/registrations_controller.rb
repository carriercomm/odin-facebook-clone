class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

 def create
    build_resource(sign_up_params)

    if resource.save
      resource.create_bio
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        respond_with resource, :location => after_sign_up_path_for(resource)
      end
    else
      clean_up_passwords
      respond_with resource
    end
  end  
  private


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).push(:name, :profile_picture)
  end
    # def sign_up_params
    #   allow = [:email, :name, :password, :password_confirmation, :provider, :uid, :profile_picture]
    #   params.require(resource_name).permit(allow)
    # end

end