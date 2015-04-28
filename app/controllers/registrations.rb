module Controllers
  class Registrations < Base

    get "/sign_up" do
      erb :"registrations/sign_up", :locals => {:form => Forms::SignUp.new}
    end

    post "/sign_up" do
      form = Forms::SignUp.new(params)
      user = Services::UserManager.new.create(form)
      session[:authentication_token] = user.authentication_token
      redirect "reports/"
    end

  end
end