class DashboardController < ApplicationController

  layout 'dashboard'

  def index
    
    @dashboard = Dashboard.new(current_user)
    
  end

end
