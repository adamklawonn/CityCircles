# coding: utf-8

module Typus

  class << self

    def version
      @@version ||= File.read("#{root}/VERSION").strip
    end

    def root
      File.dirname(__FILE__) + '/../'
    end

    def locales
      [ [ "German", 'de' ],
        [ "English", 'en' ], 
        [ "Español", 'es' ],
        [ "Français", 'fr' ],
        [ "Portuguese", 'pt-BR' ], 
        [ "Russian", 'ru' ] ]
    end

    def applications
      Typus::Configuration.config.collect { |i| i.last['application'] }.compact.uniq.sort
    end

    # List of the modules of an application.
    def application(name)
      Typus::Configuration.config.collect { |i| i.first if i.last['application'] == name }.compact.uniq.sort
    end

    ##
    # Gets a list of all the models on the configuration file.
    #
    def models
      Typus::Configuration.config.map { |i| i.first }.sort
    end

    def models_on_header
      models.collect { |m| m if m.constantize.typus_options_for(:on_header) }.compact
    end

    ##
    # List of resources, which are tableless models.
    #
    def resources
      Typus::Configuration.roles.keys.map do |key|
        Typus::Configuration.roles[key].keys
      end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
    end

    ##
    # Gets a list of models under app/models
    #
    def discover_models
      all_models = []
      Dir.chdir(File.join(Rails.root, 'app/models')) do
        Dir['**/*.rb'].each do |m|
          class_name = m.sub(/\.rb$/,'').camelize
          klass = class_name.split('::').inject(Object){ |klass,part| klass.const_get(part) }
          all_models << "#{class_name}" if klass < ActiveRecord::Base && !klass.abstract_class?
        end
      end
      return all_models
    end

    def user_class
      Typus::Configuration.options[:user_class_name].constantize
    end

    def user_fk
      Typus::Configuration.options[:user_fk]
    end

    def relationship
      Typus::Configuration.options[:relationship]
    end

    def testing?
      Rails.env.test? && Dir.pwd == "#{Rails.root}/vendor/plugins/typus"
    end

    def plugin?
      File.directory?("#{Rails.root}/vendor/plugins/typus")
    end

    def boot!

      if testing?
        Typus::Configuration.options[:config_folder] = 'vendor/plugins/typus/test/config/working'
      end

      # Ruby Extensions
      require 'typus/hash'
      require 'typus/object'
      require 'typus/string'

      # Load configuration and roles.
      Typus::Configuration.config!
      Typus::Configuration.roles!

      # Rails Extensions.
      require 'typus/active_record'
      require 'typus/extensions/routes'

      # Mixins.
      require 'typus/authentication'
      require 'typus/format'
      require 'typus/preview'
      require 'typus/preferences'
      require 'typus/reloader'
      require 'typus/quick_edit'
      require 'typus/user'

      # Vendor.
      require 'vendor/active_record'
      require 'vendor/paginator'
      require 'vendor/rss_parser'

    end

  end

end