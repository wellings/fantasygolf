class GroupsController < ApplicationController

  def index
    if params[:search]
    	@groups = Group.search(params[:search]).order("name ASC")
    else
	@groups = Group.all
    end
  end

 def show
    @group = Group.where("id = ?", params[:id]).first
#    @members = GroupMember.where("group_id = ?", @group.id).all
    @members = User.joins(:group_members).select('distinct users.*').where("group_id = ?", @group.id).order('score asc').all
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.where("id = ?", params[:id]).first
  end

  def join
   @group = Group.where("id = ?", params[:id]).first
    if @group.private 
	redirect_to group_password_path(:id => @group.id)
    else
    @join = GroupMember.new(:user_id => current_user.id, :group_id => @group.id)
    	if @join.save
        	flash[:notice] = "#{current_user.full_name} was successfully added to #{@group.name} group."
		redirect_to group_path(:id => @group.id)
    	else
        	flash[:notice] = "#{current_user.full_name} was NOT successfully added to #{@group.name} group."
		redirect_to group_path(:id => @group.id)
    	end
    end	
  end

  def password
	@group = Group.where("id = ?", params[:id]).first
	
  end

  def verify_password
    if params[:password]
    	@group = Group.where("id = ?", params[:id]).first
	if @group.password == params[:password]
		@join = GroupMember.new(:user_id => current_user.id, :group_id => @group.id)
	    	if @join.save
        		flash[:notice] = "#{current_user.full_name} was successfully added to #{@group.name} group."
			redirect_to group_path(:id => @group.id)
	    	else
        		flash[:notice] = "#{current_user.full_name} was NOT successfully added to #{@group.name} group."
			redirect_to group_path(:id => @group.id)
	    	end
	else
		flash[:alert] = "The password you entered does NOT match our records."
		redirect_to group_path(:id => @group.id)
	end
    end
  end 

  def leave
    @leave = GroupMember.where(:id => params[:id]).first
    if @leave.destroy
        flash[:notice] = "#{current_user.full_name} was successfully removed from the #{@leave.group.name} group."
	redirect_to group_path(:id => @leave.group_id)
    else
        flash[:notice] = "#{current_user.full_name} was NOT successfully removed from the #{@leave.group.name} group."
	redirect_to group_path(:id => @leave.group_id)
    end
	
  end

  def create
    @group = Group.new(group_params)
      if @group.save
        flash[:notice] = 'Group was successfully created.'
	GroupMember.create(:user_id => current_user.id, :group_id => @group.id)
        redirect_to groups_path
      else
        flash[:alert] = 'Group was NOT successfully created.'
        render new_group_path #:action => "new" 
      end
  end

  def update
    @group = Group.where("id = ?", params[:id]).first
      if @group.update(group_params)
        flash[:notice] = 'Group was successfully updated.'
        redirect_to groups_path
      else
	flash[:alert] = 'Group was NOT successfully updated.'
        render edit_group_path #:action => "edit"
      end
  end

  def destroy
    @group = Group.where("id = ?", params[:id]).first
    if @group.destroy
	    flash[:notice] = 'Group was successfully removed.'
    else
	    flash[:alert] = 'Group was NOT successfully removed.'

    end
    redirect_to groups_path
  end
  
private

  def group_params    
    params.require(:group).permit(:name, :user_id, :password, :private, :message)
  end

end
