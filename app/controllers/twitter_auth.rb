module Controllers
  class TwitterAuth < Base
    # before do
    #   @user = session[:user]
    #   @client = TwitterOAuth::Client.new(
    #     :consumer_key => ENV['CONSUMER_KEY'] || @@config['consumer_key'],
    #     :consumer_secret => ENV['CONSUMER_SECRET'] || @@config['consumer_secret'],
    #     :token => session[:access_token],
    #     :secret => session[:secret_token]
    #   )
    #   @rate_limit_status = @client.rate_limit_status
    # end

    get '/connect' do
      request_token = @client.request_token(
        :oauth_callback => ENV['CALLBACK_URL'] || @@config['callback_url']
      )
      session[:request_token] = request_token.token
      session[:request_token_secret] = request_token.secret
      redirect request_token.authorize_url.gsub('authorize', 'authenticate') 
    end

    get '/auth' do  
      begin
        @access_token = @client.authorize(
          session[:request_token],
          session[:request_token_secret],
          :oauth_verifier => params[:oauth_verifier]
        )
      rescue OAuth::Unauthorized
      end
      
      if @client.authorized?
          session[:access_token] = @access_token.token
          session[:secret_token] = @access_token.secret
          session[:user] = true
          redirect '/timeline'
        else
          redirect '/'
      end
    end    
  end
end