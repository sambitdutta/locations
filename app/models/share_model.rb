class ShareModel < ActiveRecord::Base
  
  belongs_to :shared_to, polymorphic: true
  belongs_to :shared_from, polymorphic: true
  belongs_to :resource, polymorphic: true
  
end
