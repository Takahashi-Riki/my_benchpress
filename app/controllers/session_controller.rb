class SessionController < ApplicationController
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]

  def new
    
  end

  def create
    password_token = params[:password]
    if authenticated?(password_token, PASSWORD_DIGEST)
      log_in
      redirect_to root_url
    else
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
