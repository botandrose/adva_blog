require 'rails_helper'

RSpec.describe "Blog Index", type: :request do
  include_context :an_article

  let(:unpublished_article) { Article.find_by!(title: 'an unpublished blog article') }
  let(:another_category) { Category.find_by!(section: blog, title: 'another category') }

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
