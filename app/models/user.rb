class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.role ||= :standard }

  has_many :wikis, dependent: :destroy

  has_many :collaborators, dependent: :destroy

  enum role: [:admin, :standard, :premium]

  def is_premium?
    role == "premium"
  end

  def is_standard?
    role == "standard"
  end

  def is_admin?
    role == "admin"
  end
end
