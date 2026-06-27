class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  # GET /profile
  def show
    @posts = Post.where(user_id: @profile.user.id).order(created_at: :desc)

    # Registra visita — só se for outro usuário logado visitando
    if user_signed_in? && current_user.profile != @profile
      ProfileView.find_or_create_by(
        viewer_id: current_user.profile.id,
        viewed_id: @profile.id
      ).update!(viewed_at: Time.current)
    end

    if user_signed_in? && current_user.profile == @profile
      @visitors = @profile.views_received
                          .includes(viewer: :user)
                          .order(viewed_at: :desc)
                          .limit(10)
    end
end

  # GET /profile/edit
  def edit
  end

  # PATCH/PUT /profile
  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Finds the profile via the logged-in user's username.
  # Routes are singular (/profile), so no params[:id] is needed.
  def set_profile
    if action_name == "show"
      user = User.find_by!(username: params[:username])
      @profile = user.profile
    else
      @profile = current_user.profile
    end
  end

  def profile_params
    params.require(:profile).permit(:bio, :headline, :course, :institution, :github, :linkedin)
  end
end