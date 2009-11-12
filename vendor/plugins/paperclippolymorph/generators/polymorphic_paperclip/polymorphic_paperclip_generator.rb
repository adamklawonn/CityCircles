class PolymorphicPaperclipGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
  end
  
  def manifest
    recorded_session = record do |m|
     
      unless has_rspec?
        puts " All test for PolymorphicPaperclip are written in rSpec."
        puts " Consider installing rSpec and the rSpec on rails plugin."
      end
     
      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', 
         :assigns => { :migration_name => "PolymorphicPaperclipMigration" },
         :migration_file_name => "polymorphic_paperclip_migration"
      end
    end
    
    action = nil
    action = $0.split("/")[1]
    case action
      when "generate" 
        puts
        puts ("-" * 70)
        puts "Success!"
        puts
        puts "Dont't Forget to:"
        puts "  - Add the acts_as_polymorphic_paperclip to the model that accepts assets"
        puts " You will no longer need the has_attached_file argument in your model once you"
        puts " add this plugin."
        puts
        unless options[:skip_migration]
        puts "  - Run the migration."
        puts "      rake db:migrate"
        end
        puts
        puts
        puts ("-" * 70)
        puts
      else
        puts
    end

    recorded_session  end
  
  def has_rspec?
    options[:rspec] || (File.exist?('spec') && File.directory?('spec'))
  end
  
end
