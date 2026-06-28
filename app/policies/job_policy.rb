class JobPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def propose?
    user.profile.present? &&
    !record.already_proposed_by?(user) &&
    record.user != user
  end

  def create?
    true
  end

  def update?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end