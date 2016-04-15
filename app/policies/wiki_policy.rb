class WikiPolicy < ApplicationPolicy

  def update?
    user.present?
  end

  def create?
    user.admin? || user.premium?
  end
end
