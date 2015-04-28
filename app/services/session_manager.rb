require 'digest/md5'

module Services
  class SessionManager
    include BCrypt
    
    def create_session(params)
      user = Models::User.where(:username => params[:username]).first
      set_auth_token(user, params[:password])
      user
    end 

    private

    def set_auth_token(user, password)
      if user.password == Password.create(password)
        user.update(:authentication_token => Digest::MD5.new.to_s)
      end  
    end
  end
end
