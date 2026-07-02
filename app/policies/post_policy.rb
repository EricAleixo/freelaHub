class PostPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end