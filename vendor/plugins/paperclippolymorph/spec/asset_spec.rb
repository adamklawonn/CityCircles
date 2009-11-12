require File.dirname(__FILE__) + '/spec_helper'

describe Asset do
  before(:each) do
    @asset = Asset.new
    @uploaded_image = uploaded_jpeg("#{RAILS_ROOT}/vendor/plugins/paperclip_polymorph/spec/fixtures/assets/rails.png")
    @uploaded_text = uploaded_txt("#{RAILS_ROOT}/vendor/plugins/paperclip_polymorph/spec/fixtures/assets/sample.txt")
  end
  it "should save the uploaded attachment data" do
    @asset = create_asset(:data => @uploaded_image)
    @asset.browser_safe?.should be_true
    @asset.icon.should == "image-jpeg.png"
    @asset.name.should == @asset.data_file_name
    
    @asset = create_asset(:data => @uploaded_text)
    @asset.browser_safe?.should be_false
    @asset.icon.should == "text-plain.png"
  end
  
  it "should allow you to replace one to many styles of an associated file" do
  
  end
  
  it 'should create and destroy attachings' do
    lambda do
      @asset = create_asset(:data => @uploaded_image)
      @essay = MockEssay.create(:title => 'foo')
      @essay.assets.attach(@asset.id)
    end.should change(Attaching, :count).by(1)
    
    lambda do
      @asset.detach(@essay)
    end.should change(Attaching, :count).by(-1)
  end
  
  it "should raise exception if an invalid record is called" do
    @asset = create_asset(:data => @uploaded_image)
    lambda do
      @asset.detach(@asset)
    end.should raise_error(ActiveRecord::RecordNotFound)
  end
end
