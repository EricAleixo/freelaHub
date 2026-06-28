class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  enum :notification_type, {
    new_proposal: "new_proposal",
    proposal_accepted: "proposal_accepted",
    proposal_rejected: "proposal_rejected"
  }
end