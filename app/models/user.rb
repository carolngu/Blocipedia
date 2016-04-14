class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.role ||= :standard }

  has_many :wikis, dependent: :destroy

  enum role: [:admin, :standard, :premium]
end
