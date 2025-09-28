require 'rails_helper'

RSpec.describe "Blog Index", type: :request do
  include_context :an_article

  let!(:unpublished_article) do
    Article.create!(
      site: site,
      section: blog,
      title: 'an unpublished blog article',
      body: 'unpublished article body',
      categories: [category],
      author: user,
      published_at: nil
    )
  end

  let!(:another_category) do
    Category.create!(section: blog, title: 'another blog category')
  end

  before do
    # Set up site host for request
    host! 'site-with-blog.com'
  end

  describe "User clicks through blog frontend blog index pages" do
    it "visits blog index" do
      get "/#{blog.permalink}"

      expect(response).to render_template("blogs/articles/index")
      expect(response.body).to include(article.title)
      expect(response.body).not_to include(unpublished_article.title)
    end

    it "visits blog category index" do
      get "/#{blog.permalink}/categories/#{category.permalink}"

      expect(response).to render_template("blogs/articles/index")
      expect(response.body).to include(article.title)
      expect(response.body).not_to include(unpublished_article.title)
    end

    it "visits empty blog category index" do
      get "/#{blog.permalink}/categories/#{another_category.permalink}"

      expect(response).to render_template("blogs/articles/index")
      expect(response.body).not_to include(article.title)
      expect(response.body).not_to include(unpublished_article.title)
    end

    # TODO: Tag routes need query parameter implementation
    # it "visits blog tag index" do
    #   get "/#{blog.permalink}/tags/foo"
    #
    #   expect(response).to render_template("blogs/articles/index")
    #   expect(response.body).to include(article.title)
    #   expect(response.body).not_to include(unpublished_article.title)
    # end

    it "visits missing blog tag index" do
      get "/#{blog.permalink}/tags/does-not-exist"

      expect(response).to have_http_status(404)
    end

    # TODO: Archive routes not yet implemented
    # it "visits blog this year's archive index" do
    #   get "/#{blog.permalink}/2008"
    #
    #   expect(response).to render_template("blogs/articles/index")
    #   expect(response.body).to include(article.title)
    #   expect(response.body).not_to include(unpublished_article.title)
    # end

    # it "visits blog last year's archive index" do
    #   get "/#{blog.permalink}/2007"
    #
    #   expect(response).to render_template("blogs/articles/index")
    #   expect(response.body).not_to include(article.title)
    #   expect(response.body).not_to include(unpublished_article.title)
    # end

    # it "visits blog this month's archive index" do
    #   get "/#{blog.permalink}/2008/1"
    #
    #   expect(response).to render_template("blogs/articles/index")
    #   expect(response.body).to include(article.title)
    #   expect(response.body).not_to include(unpublished_article.title)
    # end

    # it "visits blog last month's archive index" do
    #   get "/#{blog.permalink}/2007/12"
    #
    #   expect(response).to render_template("blogs/articles/index")
    #   expect(response.body).not_to include(article.title)
    #   expect(response.body).not_to include(unpublished_article.title)
    # end
  end
end