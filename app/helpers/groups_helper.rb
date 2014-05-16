module GroupsHelper

  def group_member
	GroupMember.where("user_id = ? and group_id = ?", current_user.id, @group.id).first
  end

end
