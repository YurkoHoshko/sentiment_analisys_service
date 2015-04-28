module Services
  class UserManager
    include BCrypt

    def create_user(sign_up_form)
      if sign_up_form.valid?
        user_attributes = build_user_parameters(sign_up_form)
        new_user = Models::User.create(user_attributes)
        SessionsManager.new.create_session(user_attributes)
      end
    end

    private
    
    def build_user_parameters(sign_up_form)
      username = sign_up_form.username
      password = Password.create(sign_up_form.username)
      {
        :username => username,
        :password => password
      }
    end
  end
end