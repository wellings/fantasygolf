class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

 def show
    @group = Group.where("id = ?", params[:id]).first
    @members = GroupMember.where("group_id = ?", @group.id).all
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.where("id = ?", params[:id]).first
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
