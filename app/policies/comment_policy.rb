class CommentPolicy < ApplicationPolicy

  attr_reader :user, :record

  def new?
    user.present? && user.admin?
  end

  def create?
    new?
  end

  def edit?
    user.present? && record.user == user || user_has_power?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end
  private

  def user_has_power?
    user.admin? || user.moderator?
  end

end