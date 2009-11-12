require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "sqlite3"])
load(File.join(plugin_spec_dir, "db", "schema.rb"))


def uploaded_file(path, content_type="application/octet-stream", filename=nil)
  filename ||= File.basename(path)
  t = Tempfile.new(filename)
  FileUtils.copy_file(path, t.path)
  (class << t; self; end;).class_eval do
    alias local_path path
    define_method(:original_filename) { filename }
    define_method(:content_type) { content_type }
  end
  return t
end

class MockEssay < ActiveRecord::Base
  acts_as_polymorphic_paperclip :counter_cache => true
end

class MockPhotoEssay < ActiveRecord::Base
  acts_as_polymorphic_paperclip
end


# A JPEG helper
def uploaded_jpeg(path, filename = nil)
  uploaded_file(path, 'image/jpeg', filename)
end

# A TXT helper
def uploaded_txt(path, filename = nil)
  uploaded_file(path, 'text/plain', filename)
end

def create_asset(opts = {})
  lambda do
    @asset = Asset.create(opts)
  end.should change(Asset, :count).by(1)
  @asset
end

