class GroupMember < ActiveRecord::Base

	has_many :users
	has_many :groups
	belongs_to :user
	belongs_to :group


end
