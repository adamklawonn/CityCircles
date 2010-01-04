class RssParser

  require 'rexml/document'

  def self.run(url)
    xml = REXML::Document.new Net::HTTP.get(URI.parse(url))
    data = { :title => xml.root.elements['channel/title'].text, 
             :home_url => xml.root.elements['channel/link'].text, 
             :rss_url => url, 
             :items => [] }
    xml.elements.each '//item' do |item|
      new_items = {} and item.elements.each do |e|
        new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
      end
      data[:items] << new_items
    end
    data
  end

end