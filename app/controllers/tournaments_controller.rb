class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

 def show
    @tournament = Tournament.where("id = ?", params[:id])
  end

  def new
    @tournament = Tournament.new
  end

  def edit
    @tournament = Tournament.where("id = ?", params[:id]).first
  end

  def create
    @tournament = Tournament.new(tournament_params)

      if @tournament.save
        flash[:notice] = 'Tournament was successfully created.'
        redirect_to tournaments_path
      else
        flash[:alert] = 'Tournament was NOT successfully created.'
        render new_tournament_path #:action => "new" 
      end
  end

  def update
    @tournament = Tournament.where("id = ?", params[:id]).first

      if @tournament.update(tournament_params)
        flash[:notice] = 'Tournament was successfully updated.'
        redirect_to tournaments_path
      else
	flash[:alert] = 'Tournament was NOT successfully updated.'
        render edit_tournament_path #:action => "edit"
      end
  end

  def destroy
    @tournament = Tournament.where("id = ?", params[:id]).first
    if @tournament.destroy
	    flash[:notice] = 'Tournament was successfully removed.'
    else
	    flash[:alert] = 'Tournament was NOT successfully removed.'

    end
    redirect_to tournaments_path
  end
  
  def activate
	Tournament.update_all(:active => false)
	@tournament = Tournament.where("id = ?", params[:id]).first
	@tournament.update_column(:active, true)
     redirect_to tournaments_path
  end

private

  def tournament_params    
    params.require(:tournament).permit(:name, :date, :year, :web_id, :active)
  end





end
