class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { student: 0, contractor: 1, admin: 2 }

  has_one :profile, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  after_create :build_default_profile

  # Retorna as iniciais do nome (ex: "João Pedro Silva" => "JS")
  def initials
    return "??" if full_name.blank?

    parts = full_name.split
    first = parts[0]
    second = parts[1]

    letters = second ? "#{first[0]}#{second[0]}" : first[0]
    letters.upcase
  end

  private

  def build_default_profile
    create_profile! unless profile.present?
  end
end