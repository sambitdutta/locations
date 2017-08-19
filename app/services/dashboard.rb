class Dashboard
  
  def initialize(user)
    @user = user
  end
  
  def shared_by_me(only_public = nil)
    if only_public
      PublicLocation.where(user_id: @user.id)
    else
      Location.where(user_id: @user.id)
    end
    
  end
  
  def shared_with_me
    @user.shared_to_locations
  end
  
end