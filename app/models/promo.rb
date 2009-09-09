class Promo < ActiveRecord::Base
  has_many :comments, :as => :commenter
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
end
