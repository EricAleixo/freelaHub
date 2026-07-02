class Users::RegistrationsController < Devise::RegistrationsController
    layout "auth"

    skip_before_action :authenticate_user!, only: [:check_username], raise: false
    # GET /check_username?username=foo
    def check_username
        username = params[:username].to_s.strip
    
        exists = username.present? && User.exists?(["lower(username) = ?", username.downcase])
    
        render json: { exists: exists }
    end
 

end
