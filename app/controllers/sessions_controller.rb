class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # Sign in and redirect to user profile page
      sign_in user
      redirect_back_or user
    else
      # Send error message and render the form again
      flash.now[:danger] = "Incorrect email/password combination"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
