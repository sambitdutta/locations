class LocationsController < ApplicationController
  
  def new
    @share_location_form = ShareLocationForm.new(current_user)
    render partial: "new"
  end
  
end
