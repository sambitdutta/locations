class ShareLocationForm

  include ActiveModel::Model

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def initialize(user, community)
    @user = user
    @community = community
  end

  def post
    @post ||= post_class.constantize.new
  end

  attr_accessor :id, :title, :body, :tag_list, :attachments, :community_id, :user_id, :post_status_id, :post_class, :is_featured

  validates_presence_of :post_status_id, :body, :title, :user_id, :community_id
  validates_length_of :title, :minimum => 10
  #  validates_format_of :tag_list, :with => /\A[a-zA-Z 0-9,]+\Z/, :message => "can have alphanumeric characters only", :allow_blank => true
  validates :tag_list, format: { with: /\A[a-zA-Z 0-9,]+\Z/, message: "only allows alphanumeric characters" }, allow_blank: true
  #  validates_associated :documents, :message => "should not contain the invalid files and size should be less then specified size.", :allow_blank => true
  validate :can_create_posts

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
