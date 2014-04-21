class SelectionsController < ApplicationController

  def new
    @selection = Selection.new
    if session[:select_count] == nil
	    session[:select_count] = 1
    end
    golfers_available
  end

  def start_over
    selections = Selection.where(user_id: current_user)
    for select in selections
      Selection.find(select.id).destroy
      logger.info "user id #{current_user} removed selections"
    end
    @selection = Selection.new
    session[:select_count] = 1
    golfers_available
    render :action => 'new'
  end

  def create
    @player_selection = Selection.new(selection_params)
    if @player_selection.save
      flash[:notice] = "Golfer #{session[:select_count]} selection was successfully created."
      session[:select_count] += 1
      if session[:select_count] < 11 
        redirect_to new_selection_path(current_user)
      else
        redirect_to '/'
      end
    else
     golfers_available
     render new_selection_path
    end
  end

  def edit
    
    session[:select_count] = params[:select_count].to_i
    golfers_available   

  end

  def update
    @player_selection = Selection.find(params[:player_selection][:id])
    if @player_selection.update_attributes(params[:player_selection])
      flash[:notice] = 'Golfer Select was successfully updated.'
      redirect_to '/'
    else
      render :action => 'edit'
    end
  end

  def destroy
    PlayerSelection.find(params[:id]).destroy
    logger.info "Deleted Player Selection with id = #{params[:id]}"
    redirect_to :action => 'list'
  end

  def show_golfers
    @player = Player.find(params[:id])
    @golfers = PlayerSelection.find(:all,
                                    :conditions => ['player_id = ?', params[:id]])
  end

  def update_score_rank
    @players = Player.find(:all)
    for player in @players
      rank = 0
      @player_selection = PlayerSelection.find(:all,
                                             :conditions => ['player_id = ?', player.id])
      for selection in @player_selection
        rank = rank + 1;
        score_rank = PlayerSelection.find(selection.id)
        score_rank.rank = rank
        score_rank.save

        player = Player.find(selection.player_id)
        player.score = PlayerSelection.sum('golfers.score', :include => 'golfer', :conditions => ['player_id = ? and player_selections.rank < 6', selection.player_id])
        player.save
      end 
    end
    redirect_to '/'
  end

private

def golfers_available
    case session[:select_count]
      when 1 then start_golfer = 0
                end_golfer = 7
      when 2 then start_golfer = 6
                end_golfer = 13
      when 3 then start_golfer = 12
                end_golfer = 19
      when 4 then start_golfer = 18
                end_golfer = 25
      when 5 then start_golfer = 24
                end_golfer = 31
      when 6 then start_golfer = 30
                end_golfer= 37
      when 7 then start_golfer = 36
                end_golfer = 100
      when 8 then start_golfer = 36
                end_golfer = 100
      when 9 then start_golfer = 36
                end_golfer = 100
      when 10 then start_golfer = 36
                end_golfer = 100

     end
    @golfers = Golfer.find_golfers(start_golfer, end_golfer)
    @player = current_user
    @my_golfers = Selection.where(user_id: current_user)    
    @selected = Selection.where(user_id: current_user, rank: session[:select_count])    

end
private

  def selection_params    
    params.require(:selection).permit(:user_id, :golfer_id, :rank, :sort)
  end

end
