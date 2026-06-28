class ApplicationController < ActionController::Base
    include Pundit::Authorization
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_unread_notifications_count
 
    protected
 
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :role])
    end

    private

    def set_unread_notifications_count
        @unread_notifications_count = current_user.notifications.unread.count if user_signed_in?
    end

end
