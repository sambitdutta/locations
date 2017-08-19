class ShareLocationForm

  include ActiveModel::Model

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def initialize(user, location = nil)
    @user = user
    @location = location
  end
  
  def self.model_name
    ActiveModel::Name.new(self, nil, "Location")
  end
  
  delegate :name, :latitude, :longitude, :to => :location

  attr_accessor :follower_ids
  
  def location
    @location ||= Location.new
  end

  def save(params)
    self.id = params[:id] if params[:id].present?
    self.title = params[:title]
    self.body = Sanitize.clean(params[:body], Sanitize::Config::GLO)
    self.user_id = @user.id
    self.post_status_id = params[:post_status_id] || PostStatus::OPEN

    if params[:tag_list].present?
      params[:tag_list]= params[:tag_list].squeeze(" ").strip.downcase
      self.tag_list = params[:tag_list]
    end

    self.community_id = @community.id
    self.post_class = params[:post_class] || "GeneralPost"

#    if self.post_class.to_s == "WhatsNewPost"
#      post.is_featured = true
#    end

    self.attachments = params[:attachments]

    if valid?
      persist!
      post
    else
      false
    end
  end

  private

  def can_create_posts

    unless @community.can_create_posts?(@user)
      self.errors.add(:base, "You are not authorized to create post in this communiy")
    end
    
  end

  def persist!

    ActiveRecord::Base.transaction do
      post.title = title
      post.body = body
      post.user_id = user_id
      post.post_status_id = post_status_id
      post.tag_list = Tag.sanitize(tag_list) if tag_list.present?
      post.community_ids = [community_id]

      #handle attachment
      if attachments.present?
#        Document.validate_content_type(:all)
        attachments.each do |file|
          post.documents.build(:data => file, :title => 'Post Attachment', :creator_id => user_id, :post_type => post.type)
        end
      end

      post.viewerships.build(:user_id => user_id, :subscription => 1)

      if post.save
        GloMemcache.set_community_posts_in_memcache(@community.id) ## Resetting MemCache
        GloMemcache.set_post_counts_of_a_community(@community.id) ## Resetting MemCache
        GloMemcache.set_post_details(post.id) ## Resetting MemCache
#        @community.delay.atomic_update!(:posts_count => @community.posts.count)
        Delayed::Job.enqueue AtomicUpdateJob.new(@community, {:posts_count => @community.posts.count})
      else
        #        raise post.errors.full_messages
      end

    end

  end

end
