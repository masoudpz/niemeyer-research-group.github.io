# adapted from James Hamann's Ruby Gem: https://github.com/jameshamann/jekyll-display-medium-posts

require 'feedjira'
require 'jekyll'

module Jekyll
  class JekyllDisplayMediumPosts < Generator
    safe true
    priority :high

def generate(site)
      jekyll_coll = Jekyll::Collection.new(site, 'medium_posts')
      site.collections['medium_posts'] = jekyll_coll
Feedjira::Feed.fetch_and_parse("https://medium.com/feed/nrg-excitations").entries.each do |e|
        p "Title: #{e.title}, published on Medium #{e.url} #{e.published}"
        title = e[:title]
        content = e[:content]
        guid = e[:url]
        path = "./medium_posts/" + title + ".md"
        path = site.in_source_dir(path)
        doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
        doc.data['title'] = title;
        doc.data['feed_content'] = content;
        doc.data['medium_link'] = e.url;
        doc.data['date'] = e.published
        jekyll_coll.docs << doc
      end
    end
  end
end
