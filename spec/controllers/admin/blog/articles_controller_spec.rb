require 'rails_helper'

RSpec.describe Admin::Blog::ArticlesController, type: :controller do
  include_context :a_blog
  include_context :an_article

  describe "inheritance" do
    it "inherits from Admin::Page::ArticlesController" do
      expect(described_class.superclass.name).to eq("Admin::Page::ArticlesController")
    end
  end

  describe "GET #index" do
    before do
      # Set up the section that would normally come from parent controller
      controller.instance_variable_set(:@section, blog)
    end

    it "assigns articles from the section" do
      controller.index

      expect(assigns(:contents)).to eq(blog.articles)
    end
  end
end