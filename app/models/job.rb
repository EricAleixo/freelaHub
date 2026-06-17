class Job < ApplicationRecord
  belongs_to :user

  has_many :proposals, dependent: :destroy

  enum status: { draft: 0, open: 1, paused: 2, closed: 3 }

  validates :title, presence: true
  validates :description, presence: true
  validates :budget, numericality: { greater_than: 0 }, allow_nil: true
end