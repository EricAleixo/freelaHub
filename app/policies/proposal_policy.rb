class ProposalPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # def resolve
    #   scope.where(profile: user.profile)
    # end
  end

  def create?
    user.profile.present? &&
    !record.job.already_proposed_by?(user) &&
    record.job.user != user
  end

  def accept?
    record.job.user == user
  end

  def reject?
    record.job.user == user
  end
end