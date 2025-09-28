require 'rails_helper'

RSpec.describe "Blog Article", type: :request do
  include_context :an_article

  let(:unpublished_article) { Article.find_by!(title: 'an unpublished blog article') }

  before do
    host! 'site-with-blog.com'
    # TODO: Implement time stubbing when needed
    # allow(Time).to receive(:now).and_return(Time.utc(2008, 1, 2))
  end

  describe "User clicks through blog frontend blog article show pages" do
    it "visits published article page" do
      get "/#{blog.permalink}/2008/1/1/a-blog-article"

      expect(response).to render_template("blogs/articles/show")
      expect(response.body).to include(article.title)
      # TODO: Test comments when comment system is implemented
      # expect(response.body).to include(article.approved_comments)
    end

    it "visits unpublished article page as anonymous" do
      get "/#{blog.permalink}/2008/1/1/an-unpublished-blog-article"

      expect(response).to have_http_status(404)
    end

    # TODO: Implement when authentication system is ready
    # it "visits unpublished article page as admin" do
    #   login_as_superuser
    #   get "/#{blog.permalink}/2008/1/1/an-unpublished-blog-article"
    #
    #   expect(response).to render_template("blogs/articles/show")
    #   expect(response.body).to include(unpublished_article.title)
    # end
  end
end
