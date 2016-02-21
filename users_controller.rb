class UsersController < ApplicationController

 before_action :confirm_logged_in, :except => [:upload, :login, :attempt_login, :logout, :signup, :create, :homepage]
  def signup
  	@user=User.new
  end

  def login
  end

  def create
  	@user=User.new(user_params)
    if @user.save
   	  session[:user_id] = @user.id
      session[:username] = @user.username
   	  flash[:notice] = "You succeessfully signed up!"
   	  redirect_to(:action => 'material')
   else
   	  render'signup'
   end
  end

  def material
         
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end
    if authorized_user
      # TODO: mark user as logged in
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      flash[:notice] = "You are now logged in."
      redirect_to(:action => 'material')
    else
      flash[:notice] = "Invalid username/password combination."
      redirect_to(:action => 'login')
    end
  end

  def logout
    # TODO: mark user as logged out
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
 
  private
  def user_params
      params.require(:user).permit(:username, :password,:password_confirmation)
  end
end