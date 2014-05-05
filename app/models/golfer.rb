class Golfer < ActiveRecord::Base

  belongs_to :selections, dependent: :delete
	
  validates :rank, :first_name, :last_name, presence: true



def full_name
  self.first_name + ' ' + self.last_name
end

def self.find_golfers(start_golfer, end_golfer)
    where(['rank > ? and rank < ?', start_golfer, end_golfer]).order('golfers.rank asc, golfers.last_name asc')
end

end
