class Selection < ActiveRecord::Base

belongs_to :user
belongs_to :golfer

  validates	:golfer_id, presence: true
  validates	:rank, uniqueness: { scope: :user_id}

end
