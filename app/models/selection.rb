class Selection < ActiveRecord::Base

belongs_to :user
belongs_to :golfer

  validates	:golfer_id, presence: true
  validates	:sort, uniqueness: { scope: :user_id}

end
