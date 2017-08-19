class PeopleController < ApplicationController
  
  layout 'dashboard'
  
  before_action :verify_user!, only: :show
  
  def index
    @followers = current_user.people_who_follow.where("users.username like ?", "%#{params[:q]}%")
  end
  
  def show
    @dashboard = Dashboard.new(@user)
  end
  
  private
  
  def verify_user!
    unless @user = User.where(username: params[:username]).first
      flash[:alert] = "Username does not exist"
      redirect_to root_path
    end
  end
  
end
