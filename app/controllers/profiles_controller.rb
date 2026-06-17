class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  # GET /profile
  def show
  end

  # GET /profile/edit
  def edit
    puts "Olá"
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

  # Sempre o profile do usuário logado — nunca de outro usuário.
  # Não há params[:id] porque a rota é singular (/profile).
  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:bio, :course, :institution, :github, :linkedin)
  end
end