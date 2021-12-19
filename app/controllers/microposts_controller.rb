class MicropostsController < ApplicationController
  before_action :check_login
  before_action :check_admin, only: [:create, :destroy]

  def index
    @micropost = Micropost.new
    @dayposts = get_dayposts(Micropost.all)
  end

  def create
    @micropost = Micropost.new(micropost_params)
    order = get_order(Time.zone.now)
    @micropost.order = order
    if @micropost.save
      redirect_to root_path
    else
      @dayposts = get_dayposts(Micropost.all)
      render "index"
    end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    redirect_to root_path
  end

  private

    def micropost_params
      params.require(:micropost).permit(:weight, :time, :comment)
    end

    def check_login
      redirect_to login_path if !logged_in?
    end

    def check_admin
      redirect_to login_path if !admin?
    end
end
