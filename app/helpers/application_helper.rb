module ApplicationHelper

	WEB_URL = "http://sports.yahoo.com/golf/pga/players/"
	#WEB_SCORECARD = "/scorecard/2014/13"

	def tournament_year
	  Tournament.where("active=1").first.year
	end

	def tournament_web_id
	  Tournament.where("active=1").first.web_id
	end




end
