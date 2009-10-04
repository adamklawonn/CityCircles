module Admin::MapsHelper
  
  def description_form_column( record, input_name )
    text_area :record, :description, :cols => 40, :rows => 5
  end
  
end
