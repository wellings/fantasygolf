class User < ActiveRecord::Base

has_many :selections, dependent: :delete_all

  validates :first_name, :last_name, :tiebreaker, presence: true
  validates :tiebreaker, numericality: { only_integer: true }
  # validates :username, uniqueness: true, if: -> { self.username.present? }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def full_name
    self.first_name.capitalize + ' ' + self.last_name.capitalize
  end
end
