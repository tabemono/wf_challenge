class SessionsController < ApplicationController

    skip_before_action :authorized, only: [:new, :create]
    skip_before_action :verify_authenticity_token


#   def new
#     if session[:user_id]
#         redirect_to root_path
#     end
#   end


  def create
    @user = User.find_by(email: params[:email])
  
    if @user && @user.authenticate(params[:password])
        login(@user)
        if @user.organization_id == nil
            redirect_to '/welcome'
        else
            redirect_to '/profile'
        end        
    else
        render json: ['email or password is invalid'], status: 422
    end
    
  end

  def welcome 
    if current_user.organization_id == nil
        @organization = Organization.new
    else
        redirect_to profile_path
    end
  end

    def destroy 
        @user = current_user
        if @user
            logout
            redirect_to login_path
        else
            render json: ['Nobody logged in'], status: 404
        end
    end

  def profile
    if current_user.organization_id != nil
        @organization = Organization.find(current_user.organization_id)
    else
        redirect_to welcome_path
    end
  end

end