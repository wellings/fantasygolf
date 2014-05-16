class Group < ActiveRecord::Base

belongs_to :user, dependent: :destroy

  validates	:name, presence: true
  validates	:name, uniqueness: { scope: :name}

def self.search(query)
  where("name like ?", "%#{query}%")
end
end
