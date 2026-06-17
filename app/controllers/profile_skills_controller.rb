class ProfileSkillsController < ApplicationController
  before_action :authenticate_user!

  # POST /profile/skills
  # Cria a skill (se necessário) e associa ao profile do usuário logado.
  def create
    profile = current_user.profile
    skill_name = params[:skill_name]

    if skill_name.blank?
      redirect_to edit_profile_path, alert: "Type a skill name before adding."
      return
    end

    if profile.add_skill(skill_name)
      redirect_to edit_profile_path, notice: "Skill added."
    else
      redirect_to edit_profile_path, alert: "Couldn't add that skill."
    end
  end

  # DELETE /profile/skills/:id
  # Remove a associação entre o profile do usuário logado e a skill.
  # Não deleta a Skill em si (outros usuários podem ter a mesma skill).
  def destroy
    current_user.profile.remove_skill(params[:id])
    redirect_to edit_profile_path, notice: "Skill removed."
  end
end