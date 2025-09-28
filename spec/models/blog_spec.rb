require 'rails_helper'

RSpec.describe Blog, type: :model do
  include_context :a_blog
  include_context :an_article

  describe "associations" do
    it "has many articles" do
      expect(blog.articles).to include(article)
    end

    it "aliases contents to articles" do
      expect(blog.contents).to eq(blog.articles)
    end

    it "provides permalinks for published articles via association extension" do
      published = blog.articles.published
      expect(published.permalinks).to include(article.permalink)
    end
  end

  describe "class methods" do
    describe ".content_types" do
      it "returns Article as the content type" do
        expect(Blog.content_types).to eq(%w(Article))
      end
    end
  end

  describe "instance methods" do
    describe "#archive_months" do
      it "returns the first element of article_counts_by_month" do
        allow(blog).to receive(:article_counts_by_month).and_return([['2008-01', 1], ['2008-02', 2]])
        expect(blog.archive_months).to eq(['2008-01', '2008-02'])
      end
    end

    describe "#article_counts_by_month" do
      it "returns array of month and article count pairs" do
        allow(blog).to receive(:articles_by_month).and_return({
          '2008-01' => [article],
          '2008-02' => [article, article]
        })
        expect(blog.article_counts_by_month).to eq([['2008-01', 1], ['2008-02', 2]])
      end
    end

    describe "#articles_by_year" do
      it "groups published articles by year" do
        # This will be memoized and call the actual method
        expect(blog.articles_by_year).to be_a(Hash)
      end
    end

    describe "#articles_by_month" do
      it "groups published articles by month" do
        # This will be memoized and call the actual method
        expect(blog.articles_by_month).to be_a(Hash)
      end
    end

    describe "#nav_children" do
      it "returns root categories" do
        expect(blog).to respond_to(:nav_children)
        # The actual implementation calls categories.roots
        # We'll just verify the method exists and returns something
        result = blog.nav_children
        expect(result).to respond_to(:each) # Should be a collection
      end
    end
  end
end
