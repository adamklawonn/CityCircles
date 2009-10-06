class NewsController < ApplicationController
  
  def new
    @news = News.new
  end
  
end
