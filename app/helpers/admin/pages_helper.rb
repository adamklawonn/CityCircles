module Admin::PagesHelper
  
  def author_form_column( record, input_name )
    select :record, :author, User.find_admins().collect { | u | [ u.login, u.id ] if u.admin? }, :selected => current_user.id
  end
  
end
