class SessionsController < ApplicationController

  def new
  end

  def create
    u = User.find_by(email: params["email"])

    if u != nil
        if u.authenticate(params["password"])
          #cookies["user_id"] = u.id
          session["user_id"] = u.id
          redirect_to "/", notice: "Welcome back, #{u.name}!"
        else
          redirect_to "/sessions/new", notice: "Incorrect password! Try again."
        end
    else
      redirect_to "/sessions/new", notice: "Unknown user--trying signing up instead!"
    end

  end

  def destroy
    # cookies.delete("user_id")
    # cookies["user_id"] = nil
    reset_session
    redirect_to root_url, notice: "Thanks for using Warehouse on the Web!"
  end

end