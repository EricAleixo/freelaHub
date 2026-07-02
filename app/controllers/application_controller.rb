class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_notifications_count

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:full_name, :username, :role]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:full_name, :username, :role]
    )
  end

  private

  def set_unread_notifications_count
    @unread_notifications_count = current_user.notifications.unread.count if user_signed_in?
  end

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to(request.referer || root_path, alert: "Não autorizado.") }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "posts_error",
          html: "<p id='posts_error' class='text-red-500 text-sm'>Não autorizado.</p>"
        ), status: :forbidden
      end
      format.json { render json: { error: "Não autorizado." }, status: :forbidden }
    end
  end
end