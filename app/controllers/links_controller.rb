class LinksController < ApplicationController


before_action :require_login

    def require_login
        @user = User.find_by(id: session[:user_id])
        if @user.blank?
            redirect_to root_url, notice: "Please sign up or sign in to use Shortify."
        end
    end

  def index
    @links = Link.where(user_id: @user.id)
  end

  def show 
    @link = Link.find_by(short_url: params["id"])
    @link.number_of_hits = @link.number_of_hits.to_i + 1
    @link.save

    redirect_to @link.original_url
  end 

  def new 
    @link = Link.new
  end

  def create
    @link = Link.new
    @link.original_url = params["original_url"]
    @link.user_id = params["user_id"]
    require 'securerandom'
    @link.short_url = SecureRandom.urlsafe_base64(5)

    if @link.save
      redirect_to "/links", notice: 'Thanks for using Shortify!'
    else
      redirect_to "/links/new", notice: 'Please be sure to include "https://" in your url.'
    end
  end

  def destroy 

  end
end