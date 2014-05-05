class UsersController < ApplicationController

  def index
    @users = User.joins(:selections).select('distinct users.*').order('score asc').all
  end
  def golfers
    @golfers = Selection.where("user_id = ?", params[:id]).order('sort asc')
    @player = User.where("id = ?", params[:id]).first
  end

end
