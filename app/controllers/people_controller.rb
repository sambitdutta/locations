class PeopleController < ApplicationController
  
  layout 'dashboard'
  
  def index
    @followers = current_user.people_who_follow.where("users.username like ?", "%#{params[:q]}%")
  end
  
  def show
  end
end
