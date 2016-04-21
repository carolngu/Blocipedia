class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators
  has_many :collaborator_users, through: :collaborators, source: :user
  scope :visible_to, -> (user) { user ? all : where(private: false) }

  def owner
    self.user
  end

end
