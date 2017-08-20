class ShareLocationForm

  include ActiveModel::Model

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def initialize(user)
    @user = user
  end
  
  def self.model_name
    ActiveModel::Name.new(self, nil, "Location")
  end
  
  delegate :name, :latitude, :longitude, :to => :location

  attr_accessor :follower_ids
  
  validates :name, :latitude, :longitude, presence: true
  
  def location
    @location ||= Location.new
  end

  def share(params)
    
    location.name = params[:name]
    location.latitude = params[:latitude]
    location.longitude = params[:longitude]
    self.follower_ids = params[:follower_ids].to_s.scan(/\d+/).map(&:to_i)
  
    if valid?
      persist!(self.follower_ids.present? ? "PrivateLocation" : "PublicLocation")
      return true, location
    else
      return false, errors
    end
  end

  private

  def persist!(klass)
    klass = klass.constantize
    ActiveRecord::Base.transaction do
      @location = klass.create(name: location.name, latitude: location.latitude, longitude: location.longitude, user_id: @user.id)
      if self.follower_ids.present?
        User.where(id: self.follower_ids).each do |u|
          @user.share(location, u)
        end
      end
    end
  end

end
