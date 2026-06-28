class NotificationsController < ApplicationController
  before_action :authenticate_user!

    def index
        @notifications = current_user.notifications.recent.includes(:notifiable)
        @notifications.unread.update_all(read: true)
    end

    def destroy
        if params[:clear_all]
            current_user.notifications.destroy_all
        else
            current_user.notifications.find(params[:id]).destroy
        end
        redirect_to notifications_path
    end
end