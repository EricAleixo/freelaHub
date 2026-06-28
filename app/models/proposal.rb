class Proposal < ApplicationRecord
  belongs_to :profile
  belongs_to :job

  after_create :notify_job_owner

  private

  def notify_job_owner
    Notification.create!(
      user: job.user,
      notifiable: self,
      notification_type: "new_proposal",
      read: false,
      message: "#{profile.user.full_name} enviou uma proposta para \"#{job.title}\""
    )
  end
end