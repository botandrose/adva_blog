require 'rails_helper'

RSpec.describe BlogHelper, type: :helper do
  include_context :a_blog
  include_context :a_category
  include_context :an_article

  describe "#articles_title" do
    it "returns nil when no arguments provided" do
      expect(helper.articles_title).to be_nil
    end

    it "builds title with category" do
      result = helper.articles_title(category)
      expect(result).to eq("Articles about #{category.title}")
    end

    it "builds title with tags" do
      result = helper.articles_title(nil, ['ruby', 'rails'])
      expect(result).to eq("Articles tagged ruby and rails")
    end

    it "builds title with month" do
      month = Time.local(2008, 1)
      result = helper.articles_title(nil, nil, month)
      expect(result).to eq("Articles from January 2008")
    end

    it "builds title with all parameters" do
      month = Time.local(2008, 1)
      result = helper.articles_title(category, ['ruby'], month)
      expect(result).to eq("Articles from January 2008, about #{category.title}, tagged ruby")
    end

    it "applies format when provided" do
      result = helper.articles_title(category, format: '<h1>%s</h1>')
      expect(result).to include('<h1>')
      expect(result).to include('</h1>')
    end
  end

  describe "#archive_month" do
    it "returns Time object when year is provided" do
      params = { year: 2008, month: 1 }
      result = helper.archive_month(params)
      expect(result).to eq(Time.local(2008, 1))
    end

    it "returns nil when year is not provided" do
      params = { month: 1 }
      result = helper.archive_month(params)
      expect(result).to be_nil
    end

    it "handles missing month parameter" do
      params = { year: 2008 }
      result = helper.archive_month(params)
      expect(result).to eq(Time.local(2008, nil))
    end
  end

  describe "#blog_article_path" do
    it "returns permalink-based path for published articles" do
      result = helper.blog_article_path(blog, article)
      # The method actually works and returns a path
      expect(result).to include(blog.permalink)
      expect(result).to include(article.permalink)
    end

    it "returns unpublished path for unpublished articles" do
      unpublished_article = Article.new(section: blog, title: "Unpublished", published_at: nil)
      allow(helper).to receive(:unpublished_blog_article_path).and_return("/unpublished/path")

      result = helper.blog_article_path(blog, unpublished_article)
      expect(result).to eq("/unpublished/path")
    end
  end

  describe "#blog_article_url" do
    it "returns permalink-based URL for published articles" do
      result = helper.blog_article_url(blog, article)
      # The method actually works and returns a URL
      expect(result).to include(blog.permalink)
      expect(result).to include(article.permalink)
      expect(result).to start_with('http://')
    end

    it "returns unpublished URL for unpublished articles" do
      unpublished_article = Article.new(section: blog, title: "Unpublished", published_at: nil)
      allow(helper).to receive(:unpublished_blog_article_url).and_return("http://example.com/unpublished")

      result = helper.blog_article_url(blog, unpublished_article)
      expect(result).to eq("http://example.com/unpublished")
    end
  end

  describe "#absolutize_links" do
    before do
      @site = double('site', host: 'example.com')
    end

    it "converts relative hrefs to absolute URLs" do
      html = '<a href="/path">Link</a>'
      result = helper.absolutize_links(html)
      expect(result).to eq('<a href="http://example.com/path">Link</a>')
    end

    it "converts relative src attributes to absolute URLs" do
      html = '<img src="/image.jpg">'
      result = helper.absolutize_links(html)
      expect(result).to eq('<img src="http://example.com/image.jpg">')
    end

    it "handles mixed relative links" do
      html = '<a href="/link">Link</a> <img src="/image.jpg">'
      result = helper.absolutize_links(html)
      expect(result).to eq('<a href="http://example.com/link">Link</a> <img src="http://example.com/image.jpg">')
    end
  end
end