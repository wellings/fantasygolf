class ContactMailer < ActionMailer::Base
    #default to: 'jeff@hsxn.com'

    def contact_email(name, sendto, email, body)
        @name = name
	@sendto = sendto
        @email = email
        @body = body

        mail(from: email, to: sendto, subject: 'Fantasy Golf Majors')
    end

    def contact_email_group(name, sendto, email, body, group)
        @name = name
	@sendto = sendto
	@email = email
        @body = body
	@group = Group.where("id = ?", group).first

        mail(from: email, to: sendto, subject: 'Fantasy Golf Majors')
    end

end
