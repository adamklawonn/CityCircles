class News < ActiveRecord::Base
  has_many :comments, :as => :commenter
  has_many :photos, :as => :photoable
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
end
