class LocationsController < ApplicationController
  
  def new
    @share_location_form = ShareLocationForm.new(current_user)
    render partial: "new"
  end
  
  def create
    @share_location_form = ShareLocationForm.new(current_user)
    @location, @status = @share_location_form.share(location_params)
    
    if @location
      render '/locations/create/success'
    else
      render '/locations/create/error'
    end
  end
  
  private
  
  def location_params
    params.require(:location).permit(:name, :latitude, :longitude, :follower_ids)
  end
  
end
