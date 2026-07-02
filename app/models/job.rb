class Job < ApplicationRecord
  belongs_to :user
  has_many :proposals, dependent: :destroy
  has_many :posts, dependent: :nullify
  enum status: { draft: 0, open: 1, paused: 2, closed: 3 }
  
  validates :title, presence: true
  validates :description, presence: true
  validates :budget, numericality: { greater_than: 0 }, allow_nil: true

  def status_badge_class
    case status
    when "draft"
      "inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600"
    when "open"
      "inline-flex items-center gap-1 rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-medium text-emerald-700"
    when "paused"
      "inline-flex items-center gap-1 rounded-full bg-amber-100 px-2.5 py-1 text-xs font-medium text-amber-700"
    when "closed"
      "inline-flex items-center gap-1 rounded-full bg-red-100 px-2.5 py-1 text-xs font-medium text-red-700"
    end
  end

  def already_proposed_by?(user)
    return false unless user.profile
    proposals.exists?(profile: user.profile)
  end

  def human_status
    {
      "draft" => "Rabisco",
      "open" => "Aberta",
      "in_progress" => "Em andamento",
      "closed" => "Encerrada"
    }.fetch(status)
  end
end 