class Location < ActiveRecord::Base
  belongs_to :user
  shareable owner: :user
end
