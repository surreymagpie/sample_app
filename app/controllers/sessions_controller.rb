class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    #render 'new'
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign in and redirect to user profile page
      sign_in user
      redirect_to user
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
