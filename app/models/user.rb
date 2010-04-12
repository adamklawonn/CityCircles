# == Schema Information
# Schema version: 20100410232227
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)     not null
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  roles               :string(255)     default("")
#  email_verified      :boolean(1)
#  agreed_with_terms   :boolean(1)
#

class User < ActiveRecord::Base
  
  has_one :user_detail
  has_many :user_wireless_profiles
  has_many :user_locations
  has_many :comments, :foreign_key => "author_id"
  has_many :posts, :foreign_key => "author_id"
  has_many :user_interests
  has_many :user_hobbies
  has_many :organization_members
  
  acts_as_authentic

  before_validation_on_create :make_default_roles

  attr_accessible :login, :password, :password_confirmation, :email, :roles, :first_name, :last_name, :agreed_with_terms
  
  validates_presence_of :login
  validates_length_of :login, :in => 3..20
  validates_uniqueness_of :login
  validates_uniqueness_of :email
  validates_acceptance_of :agreed_with_terms, :message => "you must be abided", :on => :create, :accept => true
  
  def news
    news_type = PostType.find_by_shortname( "news" )
    Post.find( :all, :conditions => [ "author_id = ? and post_type_id = ?", self.id, news_type.id ], :limit => 10 )
  end
  
  def events
    events_type = PostType.find_by_shortname( "events" )
    Post.find( :all, :conditions => [ "author_id = ? and post_type_id = ?", self.id, events_type.id ], :limit => 10 )
  end
  
  def networks
    network_type = PostType.find_by_shortname( "network" )
    Post.find( :all, :conditions => [ "author_id = ? and post_type_id = ?", self.id, network_type.id ], :limit => 10 )
  end
  
  def stuff
    stuff_type = PostType.find_by_shortname( "stuff" )
    Post.find( :all, :conditions => [ "author_id = ? and post_type_id = ?", self.id, stuff_type.id ], :limit => 10 )
  end
  
  def self.find_admins
    self.find( :all, :conditions => "find_in_set( 'admin', users.roles )" )
  end
  
  def get_roles
    self.roles.split( "," ).collect { | r | r.strip }
  end
  
  def admin?
    has_role?( "admin" )
  end

  def org_manager?
    has_role?( "org-manager" ) && org_member?
  end

  def org_member?
    ( self.organization_members != nil && !self.organization_members.empty? ? true : false )
  end
  
  def has_role?( role )
    get_roles.include?( role )
  end

  def add_role( role )
    if !get_roles.include? role
      self.roles = get_roles.push( role ).join ","
    end    
  end

  def remove_role( role )
    current_roles = get_roles
    current_roles.delete( role )
    self.roles = current_roles.join ","
  end

  def clear_roles
    self.roles = ""
  end

  def kaboom!
    r = RegExp.new( "foo" )
  end
  
  def to_s
    login
  end
  
  def name
    login
  end
  
private
  def make_default_roles
    clear_roles if roles.empty?
  end
  
end
