class SessionsController < ApplicationController
    def new
        @user = User.new
        render :new 
    end
    
    def create 
        email = params[:user][:email]
        password = params[:user][:password]

        @user = self.find_by_credentials(email, password)

        if @user
            login!(@user)   # need to create login method
            # reset session token?
            redirect_to user_url(@user)
        else
            @user = User.new(username: username) 
            flash.new[:errors] = ["Invalid Credentials"] #error message
            render :new 
        end 
    end

    def destroy 
        if logged_in?
            logout!
        end 
    end
end
