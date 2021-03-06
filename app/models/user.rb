class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :rememberable, :trackable, :validatable, :authentication_keys => [:login]
  
  acts_as_follower
  acts_as_followable
  
  sharer
  
  has_many :follower_records, class_name: "Follow", as: :followable
  has_many :people_who_follow, class_name: "User", through: :follower_records, source: :follower, source_type: "User"
  
  has_many :shared_to, class_name: "ShareModel", as: :shared_to
  has_many :shared_to_locations, class_name: "Location", through: :shared_to, source: :resource, source_type: "Location" 
  
  validates :username, :presence => true, :uniqueness => {
    :case_sensitive => false
  }
  
  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end  
       
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end
  
end
