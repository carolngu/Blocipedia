class WikiPolicy < ApplicationPolicy
  class Scope < Scope

    def resolve
      wikis = []
      if user && user.role == "admin"
        wikis = scope.all
      elsif user && user.role == "premium"
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.owner == user || wiki.collaborator_users.include?(user)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.collaborator_users.include?(user)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end

  def update?
    user.present?
  end

  def create?
    user.admin? || user.premium?
  end


end
