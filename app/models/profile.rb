class Profile < ApplicationRecord
  belongs_to :user
 
  has_many :profile_skills, dependent: :destroy
  has_many :skills, through: :profile_skills

  has_many :views_received, class_name: "ProfileView", foreign_key: :viewed_id
  has_many :views_given,    class_name: "ProfileView", foreign_key: :viewer_id
  has_many :visitors, through: :views_received, source: :viewer
 
  def initials
    name = user.try(:full_name).presence || user.email
    name.to_s.split.map(&:first).first(2).join.upcase
  end
 
  # Cria a skill (se não existir) e a associa a este profile,
  # sem duplicar caso o profile já tenha essa skill atribuída.
  def add_skill(raw_name)
    skill = Skill.find_or_create_by_name(raw_name)
    return false if skill.nil? || skill.new_record?
 
    skills << skill unless skills.include?(skill)
    true
  end
 
  def remove_skill(skill_id)
    skills.delete(Skill.find_by(id: skill_id))
  end
end
