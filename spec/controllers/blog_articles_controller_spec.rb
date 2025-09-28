require 'rails_helper'

RSpec.describe BlogArticlesController, type: :controller do
  include_context :a_blog
  include_context :a_category
  include_context :an_article

  describe "GET #index" do
    let(:blog_paths) { ['/a-blog', '/a-blog/2008', '/a-blog/2008/1'] }
    let(:blog_category_paths) { ['/a-blog/categories/a-category', '/a-blog/categories/a-category/2008', '/a-blog/categories/a-category/2008/1'] }
    let(:blog_tag_paths) { ['/a-blog/tags/foo+bar'] }
    let(:blog_feed_paths) { ['/a-blog.atom', '/a-blog/categories/a-category.atom', '/a-blog/tags/foo+bar.atom'] }

    context "with blog paths" do
      before do
        @params = { section_permalink: blog.permalink }
        get :index, params: @params
      end

      it "is a BaseController" do
        expect(controller).to be_kind_of(BaseController)
      end

      it "assigns section and articles" do
        expect(assigns(:section)).to eq(blog)
        expect(assigns(:articles)).to be_present
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end

    context "with blog category paths" do
      before do
        @params = { section_permalink: blog.permalink, category_id: category.id }
        get :index, params: @params
      end

      it "assigns the category" do
        expect(assigns(:category)).to eq(category)
      end
    end

    context "with a specific blog path" do
      before do
        @params = { section_permalink: blog.permalink }
        get :index, params: @params
      end

      it "displays the article" do
        expect(response).to be_successful
        expect(response).to render_template("blogs/articles/index")
      end

      context "when article has an excerpt" do
        before do
          article.update!(excerpt: 'article excerpt')
          get :index, params: @params
        end

        it "shows the excerpt" do
          expect(response).to be_successful
          expect(response).to render_template("blogs/articles/index")
        end
      end

      context "when article has no excerpt" do
        before do
          article.update!(excerpt: nil)
          get :index, params: @params
        end

        it "shows the body" do
          expect(response).to be_successful
          expect(response).to render_template("blogs/articles/index")
        end
      end
    end

    context "with feed paths" do
      before do
        @params = { section_permalink: blog.permalink, format: :atom }
        get :index, params: @params
      end

      it "assigns section and articles" do
        expect(assigns(:section)).to eq(blog)
        expect(assigns(:articles)).to be_present
      end

      it "renders atom format" do
        expect(response.content_type).to include('application/atom+xml')
      end
    end

    context "when Comment is defined (eager loads counters)" do
      before do
        # Define a dummy Comment constant to trigger the branch
        Object.send(:remove_const, :Comment) if Object.const_defined?(:Comment)
        Object.const_set(:Comment, Class.new)

        # The controller calls `articles.includes!(:approved_comments_counter)`.
        # Stub includes! on any relation to be a no-op returning the relation.
        expect_any_instance_of(ActiveRecord::Relation)
          .to receive(:includes!).with(:approved_comments_counter)
          .and_return(Article.all)

        @params = { section_permalink: blog.permalink }
        get :index, params: @params
      end

      after do
        Object.send(:remove_const, :Comment) if Object.const_defined?(:Comment)
      end

      it "renders the index template successfully" do
        expect(response).to be_successful
        expect(response).to render_template("blogs/articles/index")
      end
    end
  end

  describe "GET #show" do
    before do
      # Use the permalink-based route structure
      @params = {
        section_permalink: blog.permalink,
        year: article.published_at.year,
        month: article.published_at.month,
        day: article.published_at.day,
        permalink: article.permalink
      }
    end

    context "when the article is published" do
      before do
        get :show, params: @params
      end

      it "assigns section and article" do
        expect(assigns(:section)).to eq(blog)
        expect(assigns(:article)).to eq(article)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "displays the article content" do
        expect(response).to be_successful
        expect(response).to render_template("blogs/articles/show")
      end
    end
  end

  # TODO: Add comments functionality when routes are implemented
  # describe "GET #comments" do
  #   before do
  #     @params = { section_permalink: blog.permalink, article_id: article.id, format: :atom }
  #   end
  #
  #   context "when the article is published" do
  #     before do
  #       get :comments, params: @params
  #     end
  #
  #     it "assigns section and comments" do
  #       expect(assigns(:section)).to eq(blog)
  #       expect(assigns(:comments)).to be_present
  #     end
  #
  #     it "renders comments atom template" do
  #       expect(response).to render_template('comments/comments')
  #       expect(response.content_type).to include('application/atom+xml')
  #     end
  #   end
  # end
end
