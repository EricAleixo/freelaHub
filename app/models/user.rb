class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { student: 0, contractor: 1, admin: 2 }

  has_one :profile, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :notifications, dependent: :destroy

  after_create :build_default_profile

  private

  def build_default_profile
    create_profile! unless profile.present?
  end
end