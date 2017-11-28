class UsersController < ApplicationController

  def new
  end

  def create
    user = User.new
    user.name = params['name']
    user.email = params['email']
    user.password = params['password']
    require 'securerandom'
    user.api_key = SecureRandom.urlsafe_base64(32)
    user.save
    redirect_to root_url, notice: "Thanks for signing up for a developer account!"
  end

  def destroy 
    User.find(session[:user_id]).destroy      
    session[:user_id] = nil         
    redirect_to root_url, notice: "Your account has been deleted."
  end 
end