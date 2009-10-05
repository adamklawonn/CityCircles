# == Schema Information
# Schema version: 20091005071144
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
#

class User < ActiveRecord::Base

  has_one :user_profile
  has_many :user_wireless_profiles

  acts_as_authentic

  before_validation_on_create :make_default_roles

  attr_accessible :login, :password, :password_confirmation, :email, :first_name, :last_name
  
  validates_presence_of :login
  validates_length_of :login, :in => 3..20
  validates_uniqueness_of :login
  
  def self.find_admins
    self.find( :all, :conditions => "find_in_set( 'admin', users.roles )" )
  end
  
  def get_roles
    self.roles.split ","
  end
  
  def admin?
    has_role?( "admin" )
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
  
private
  def make_default_roles
    clear_roles if roles.empty?
  end
  
end
