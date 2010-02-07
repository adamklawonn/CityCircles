class EmailBlast < ActiveRecord::Base
  belongs_to :blastable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :email_blast_template, :class_name => "EmailBlastTemplate", :foreign_key => "template"
end
