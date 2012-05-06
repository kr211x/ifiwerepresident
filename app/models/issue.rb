class Issue
  include Mongoid::Document
  include Mongoid::Timestamps

  POST_OPTIONS = {
    text_or_url: 0,
    url_or_text: 1,
    text_only:   2,
    url_only:    3
  }

  field :description, type: String
  field :title, type: String
  #field :post_options, type: Integer, default: POST_OPTIONS[:text_or_url]

  field :post_label, type: String, default: "Post"
  field :posts_label, type: String, default: "Posts"
  field :new_post_label, type: String, default: "New Post"

  has_many :proposals
  has_many :participations, :dependent => :destroy
  has_many :tags
  has_many :pages
  belongs_to :theme
  belongs_to :user, index: true

  def add_member user
    if p = participations.where(:user_id => user.id).first
      p.update_attribute :hidden, false if p.hidden?
    else
      participations.create!(:user => user, :level => Participation::MEMBER)
    end
  end

  def add_admin user
    participations.create!(:user => user, :level => Participation::ADMIN)
  end

  def add_owner user
    participations.create!(:user => user, :level => Participation::OWNER)
  end

end
