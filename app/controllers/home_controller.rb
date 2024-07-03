require 'nokogiri'
require 'open-uri'

class HomeController < ApplicationController
  def index
    @movies = scrape_movies
  end

  private

  def scrape_movies
    url = 'https://www.empireonline.com/movies/features/best-movies-2/'
    html_content = URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
    doc = Nokogiri::HTML(html_content)
    movies = doc.css('div.listicle_listicle__item__CJna4')

    movies.map do |movie|
      title = movie.css('h3.listicleItem_listicle-item__title__BfenH').text.strip
      description = movie.css('div.listicleItem_listicle-item__content__Lxn1Y > p').first.text.strip
      image_element = movie.css('img').first
      image_url = image_element ? image_element.attr('src') : 'default_image_url.jpg'

      { title: title, description: description, image_url: image_url }
    end
  end
end