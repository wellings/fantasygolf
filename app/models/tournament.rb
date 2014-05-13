class Tournament < ActiveRecord::Base

 validates :name, :web_id, :year, presence: true

end
