require File.dirname(__FILE__) + '/spec_helper'

describe MockEssay, :type => :model do
  before(:each) do
    @uploaded_image = uploaded_jpeg("#{RAILS_ROOT}/vendor/plugins/paperclip_polymorph/spec/fixtures/assets/rails.png")
    @uploaded_text = uploaded_txt("#{RAILS_ROOT}/vendor/plugins/paperclip_polymorph/spec/fixtures/assets/sample.txt")
  end
  
  describe 'when being saved' do
    it 'should create an asset after being saved' do
      lambda do
        MockEssay.create(:title => 'foo', :data => @uploaded_image)
      end.should change(Asset, :count).by(1)
    end
  end
  
  describe 'when being deleted' do
    it 'should not delete any of the attached assets' do
      lambda do
        @essay = MockEssay.create(:title => 'foo', :data => @uploaded_image)
      end.should change(Asset, :count).by(1)
      
      lambda do
        @essay.destroy
        lambda do
          MockEssay.find(@essay)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end.should_not change(Asset, :count)
    end
  end
    
  describe 'when using a counter cache' do
    it "should increment and decrement the counter after save and destroy" do
      lambda do
        @essay = MockEssay.create(:title => 'foo')
        @asset = create_asset(:data => @uploaded_image)
      end.should change(Asset, :count).by(1)
      lambda do
        lambda do
          @essay.assets.attach(@asset)
          @essay.reload
          @asset.reload
        end.should change(@essay, :assets_count).by(1)
      end.should change(@asset, :attachings_count).by(1)
      lambda do
        lambda do
          @essay.assets.detach(@asset)
          @asset.reload
          @essay.reload
        end.should change(@essay, :assets_count).by(-1)
      end.should change(@asset, :attachings_count).by(-1)
    end
  end
  
  describe 'when being attached to a model with content-type restrictions' do
    it 'should allow only files of the accepted type to be saved and attached'
  end
end
