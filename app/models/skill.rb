class Skill < ApplicationRecord
  has_many :profile_skills, dependent: :destroy
  has_many :profiles, through: :profile_skills
 
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
 
  before_validation :normalize_name
 
  # Busca uma skill existente ignorando maiúsculas/minúsculas e espaços,
  # ou cria uma nova caso não exista. Usado ao usuário digitar uma skill
  # nova no campo de texto livre.
  def self.find_or_create_by_name(raw_name)
    clean_name = raw_name.to_s.strip
    return nil if clean_name.blank?
 
    find_by("LOWER(name) = ?", clean_name.downcase) || create(name: clean_name)
  end
 
  private
 
  def normalize_name
    self.name = name.to_s.strip
  end
end
 
