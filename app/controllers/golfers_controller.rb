class GolfersController < ApplicationController
 
     
  def index
    @golfers = Golfer.order('last_name asc, first_name asc').all
  end

  def show
    @golfer = Golfer.where("id = ?", params[:id])
  end

  def new
    @golfer = Golfer.new
  end

  def edit
    @golfer = Golfer.where("id = ?", params[:id]).first
  end

  def create
    @golfer = Golfer.new(golfer_params)

      if @golfer.save
        flash[:notice] = 'Golfer was successfully created.'
        redirect_to golfers_path
      else
        flash[:alert] = 'Golfer was NOT successfully created.'
        render new_golfer_path #:action => "new" 
      end
  end

  def update
    @golfer = Golfer.where("id = ?", params[:id]).first

      if @golfer.update(golfer_params)
        flash[:notice] = 'Golfer was successfully updated.'
        redirect_to golfers_path
      else
	flash[:alert] = 'Golfer was NOT successfully updated.'
        render edit_golfer_path #:action => "edit"
      end
  end

  def destroy
    @golfer = Golfer.where("id = ?", params[:id]).first
    if @golfer.destroy
	    flash[:notice] = 'Golfer was successfully removed.'
    else
	    flash[:alert] = 'Golfer was NOT successfully removed.'

    end
    redirect_to golfers_path #:controller => 'golfers'
  end
  
  
  def update_rank
    params[:golfer].each do |idx, golfer|
      golfer_rank = Golfer.find(idx)
      golfer_rank.update_attributes(golfer)
    end
    flash[:notice] = 'Golfer rank was successfully updated.'
    redirect_to golfer_rank_path
  end

  def manual_score_update
    @golfers = Golfer.find_by_sql('SELECT  DISTINCT ( golfer_id ), golfers.id, first_name, last_name, score, thru, web_id 
  FROM selections, golfers WHERE golfers.id = selections.golfer_id
  and golfers.score<>99 ORDER BY last_name ASC')
  end

  def score_update_manually
    params[:golfer].each do |idx, golfer|
      golfer_score = Golfer.find(idx)
      golfer_score.update_attributes(golfer)
    end
    flash[:notice] = 'Golfer scores were successfully updated.'

    @players = User.all
    for player in @players
      sort = 0
      @player_selection = Selection.includes(:golfer).where("user_id = ?", player.id).order('golfers.score asc').all

      for selection in @player_selection
        sort += 1
        score_sort = Selection.where("id = ?", selection.id).first
        score_sort.sort = sort
        score_sort.save

        player = User.where("id = ?", selection.user_id).first
        player.score = Selection.includes(:golfer).where("user_id = ? and selections.sort < 6", selection.user_id).sum('golfers.score')
        player.save
      end 
    end
    ActiveRecord::Base.connection.execute("SET @rnk=0;")
    ActiveRecord::Base.connection.execute("SET @rank=0;")    
    ActiveRecord::Base.connection.execute("SET @curscore=0;")
    ActiveRecord::Base.connection.execute("update users u join
						(
						select AA.*, BB.id,
						(@rnk:=@rnk+1) rnk,
						(@rank:=IF(@curscore=AA.score,@rank, @rnk)) rank,
						(@curscore:=AA.score) as newscore
						FROM
						(
						select * from
						(select count(1) scorecount,score
						FROM users 
						where id in (select distinct user_id from selections)
						GROUP BY score
						) AAA
						) AA left join users BB on (BB.score = AA.score and BB.id in (select distinct user_id from selections))
						order by score asc) A
						set u.rank = A.rank
						where u.id in (select distinct user_id from selections)
						and u.id = A.id;")
    ActiveRecord::Base.connection.execute("UPDATE users	SET rank = 1 where rank = 0 and id in (select distinct user_id from selections);")

    redirect_to '/'
  end

 def list
   
   if params[:sort].blank? || params[:sort] == 'last_name'
    sort = 'last_name'
   else
    sort = 'score'
   end

   @golfers = Golfer.find_by_sql("SELECT  DISTINCT ( golfer_id ), golfers.id, first_name, last_name, score, web_id, thru 
  FROM selections, golfers WHERE golfers.id = selections.golfer_id and golfers.score<>99 ORDER BY #{sort} ASC")
  
 end
 
 def who_has
   @users = Selection.where("golfer_id = ?", params[:id]).all
   @golfer = Golfer.where("id = ?", params[:id]).first
 end

 def golfer_scores
    require 'open-uri'
    require 'nokogiri'

   @golfers = Golfer.find_by_sql('SELECT  DISTINCT ( golfer_id ), golfers.id, first_name, last_name, score, thru, web_id
       FROM selections, golfers WHERE golfers.id = selections.golfer_id
       and golfers.score<>99 ORDER BY last_name ASC')

  for golfer in @golfers

    	  retryable(:tries => 5, :on => OpenURI::HTTPError) do
      @doc = Nokogiri::HTML(open("#{ApplicationHelper::WEB_URL}#{golfer.first_name}+#{golfer.last_name}/#{golfer.web_id}#{ApplicationHelper::WEB_SCORECARD}"))
      logger.info "#{ApplicationHelper::WEB_URL}#{golfer.first_name}+#{golfer.last_name}/#{golfer.web_id}#{ApplicationHelper::WEB_SCORECARD}"
    end

    score = @doc.search("//div[@class='playerStats']/ul/li[5]/span").inner_html
    thru = @doc.search("//div[@class='playerStats']/ul/li[4]/span").inner_html
    if score == "-" 
	    score = 99 
    end
    
    golfer_score = Golfer.where("id = ?", golfer.id).first
    golfer_score.update_attribute('score', score)
    golfer_score.update_attribute('thru', thru)

  end
    
    @players = User.all
    for player in @players
      sort = 0
      @player_selection = Selection.includes(:golfer).where("user_id = ?", player.id).order('golfers.score asc').all

      for selection in @player_selection
        sort += 1
        score_sort = Selection.where("id = ?", selection.id).first
        score_sort.sort = sort
        score_sort.save

        player = User.where("id = ?", selection.user_id).first
        player.score = Selection.includes(:golfer).where("user_id = ? and selections.sort < 6", selection.user_id).sum('golfers.score')
        player.save
      end 
    end
    ActiveRecord::Base.connection.execute("SET @rnk=0;")
    ActiveRecord::Base.connection.execute("SET @rank=0;")    
    ActiveRecord::Base.connection.execute("SET @curscore=0;")
    ActiveRecord::Base.connection.execute("update users u join
						(
						select AA.*, BB.id,
						(@rnk:=@rnk+1) rnk,
						(@rank:=IF(@curscore=AA.score,@rank, @rnk)) rank,
						(@curscore:=AA.score) as newscore
						FROM
						(
						select * from
						(select count(1) scorecount,score
						FROM users 
						where id in (select distinct user_id from selections)
						GROUP BY score
						) AAA
						) AA left join users BB on (BB.score = AA.score and BB.id in (select distinct user_id from selections))
						order by score asc) A
						set u.rank = A.rank
						where u.id in (select distinct user_id from selections)
						and u.id = A.id;")
    ActiveRecord::Base.connection.execute("UPDATE users	SET rank = 1 where rank = 0 and id in (select distinct user_id from selections);")

    redirect_to '/'
        
end


private

  def golfer_params    
    params.require(:golfer).permit(:first_name, :last_name, :rank, :web_id)
  end

  def selection_params    
    params.require(:selection).permit(:user_id, :sort, :rank, :golfer_id)
  end

def retryable(options = {}, &block)
  opts = { :tries => 10, :on => Exception }.merge(options)

  retry_exception, retries = opts[:on], opts[:tries]

  begin
    return yield
  rescue retry_exception
    retry if (retries -= 1) > 0
  end

  yield
 end

end
