module Controllers
  class Sessions < Base

    get "/sign_in" do
      erb :"sessions/sign_in"
    end
    
    post "/sign_in" do
      Services::SessionManager.new.create(params)
    end    
  end
end