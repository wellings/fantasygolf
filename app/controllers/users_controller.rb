class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def golfers
    @golfers = Selection.where("user_id = ?", params[:id]).order('sort asc')
    @player = User.where("id = ?", params[:id]).first
  end

end
