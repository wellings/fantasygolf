class ContactsController < ApplicationController


def index
    @group = Group.where("id = ?", params[:group]).first
end 

def send_mail
    name = params[:name]
    sendto = params[:sendto]
    email = params[:email]
    body = params[:body]
    group = params[:group]
    if group.blank?
	ContactMailer.contact_email(name, sendto, email, body).deliver
	redirect_to root_path, notice: 'Email Invitation was sucessfully sent.'
    else
	ContactMailer.contact_email_group(name, sendto, email, body, group).deliver
	redirect_to group_path(group), notice: 'Email Invitation was sucessfully sent.'
    end
end


end
