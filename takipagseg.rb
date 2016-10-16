require 'open-uri'
require 'nokogiri'
require 'json'

site_url = 'https://www.residentadvisor.net'
list_url = '/podcast.aspx'

list = Nokogiri::HTML(open(site_url + list_url))

def get_download_url(url_of_show)
  podcast_doc = Nokogiri::HTML(open(url_of_show))
  podcast_doc.xpath('//*[@id="downloads"]/li[1]/a').each do |element|
    return element[:href]
  end
end

shows = []

list.css('.standard').each do |show|
  article_title = show.css('a')[2].text.strip
  article_url = show.css('a')[2]['href']
  download_url = get_download_url(site_url + article_url)
  shows.push(
    title: article_title,
    link: download_url
  )
end

puts JSON.pretty_generate(shows)
