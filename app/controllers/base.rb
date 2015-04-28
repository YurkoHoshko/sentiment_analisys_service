module Controllers
  class Base < Sinatra::Base
    set :root,  File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
    set :views, File.expand_path(File.join(File.dirname(__FILE__), "..", "views"))

    configure :development do
      register Sinatra::Reloader
    end

    set :assets_prefix, %w(app/assets)
    register Sinatra::AssetPipeline

    

    NOT_AUTHENTICATED_PATH_REGEX = (/sessions|registrations/)

    before do
      # check_user_session
    end

    private
    def check_user_session
      authentication_token = session[:authentication_token]
      user = User.where(:authentication_token => authentication_token).first

      redirect "sessions/sign_in" unless user || request_can_skip_token?
    end

    def request_can_skip_token?
      NOT_AUTHENTICATED_PATH_REGEX.match url
    end
  end
end