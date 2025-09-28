require 'rails_helper'

RSpec.describe "Blog Articles Routes", type: :routing do
  include_context :a_blog
  include_context :a_category
  include_context :an_article

  # TODO: Convert complex routing tests when routing_filters are implemented
  # This is a simplified conversion of the original routing test

  describe "blog articles routing" do
    let(:blog_id) { blog.id.to_s }

    it "routes to index" do
      expect(get: "/#{blog.permalink}").to route_to(
        controller: "blog_articles",
        action: "index",
        section_permalink: blog.permalink
      )
    end

    it "routes to show with full permalink" do
      expect(get: "/#{blog.permalink}/2008/1/1/a-blog-article").to route_to(
        controller: "blog_articles",
        action: "show",
        section_permalink: blog.permalink,
        year: "2008",
        month: "1",
        day: "1",
        permalink: "a-blog-article"
      )
    end

    it "routes to category index" do
      expect(get: "/#{blog.permalink}/categories/#{category.permalink}").to route_to(
        controller: "blog_articles",
        action: "index",
        section_permalink: blog.permalink,
        category_id: category.permalink
      )
    end

    it "routes to tag index" do
      expect(get: "/#{blog.permalink}/tags/foo+bar").to route_to(
        controller: "blog_articles",
        action: "index",
        section_permalink: blog.permalink,
        tags: "foo+bar"
      )
    end

    # TODO: Archive routes not yet implemented
    # it "routes to archive by year" do
    #   expect(get: "/#{blog.permalink}/2008").to route_to(
    #     controller: "blog_articles",
    #     action: "index",
    #     section_permalink: blog.permalink,
    #     year: "2008"
    #   )
    # end

    # it "routes to archive by year and month" do
    #   expect(get: "/#{blog.permalink}/2008/1").to route_to(
    #     controller: "blog_articles",
    #     action: "index",
    #     section_permalink: blog.permalink,
    #     year: "2008",
    #     month: "1"
    #   )
    # end

    it "routes to atom feeds" do
      expect(get: "/#{blog.permalink}.atom").to route_to(
        controller: "blog_articles",
        action: "index",
        section_permalink: blog.permalink,
        format: "atom"
      )
    end

    # TODO: Comment routes not yet implemented (requires adva_comments gem)
    # it "routes to comments feed" do
    #   expect(get: "/#{blog.permalink}/comments.atom").to route_to(
    #     controller: "blog_articles",
    #     action: "comments",
    #     section_permalink: blog.permalink,
    #     format: "atom"
    #   )
    # end

    # it "routes to article comments feed" do
    #   expect(get: "/#{blog.permalink}/2008/1/1/a-blog-article.atom").to route_to(
    #     controller: "blog_articles",
    #     action: "comments",
    #     section_permalink: blog.permalink,
    #     year: "2008",
    #     month: "1",
    #     day: "1",
    #     permalink: "a-blog-article",
    #     format: "atom"
    #   )
    # end
  end

  # TODO: Add comprehensive route generation tests when url helpers are implemented
  # describe "url helpers" do
  #   it "generates correct blog paths" do
  #     expect(blog_path(blog)).to eq("/#{blog.permalink}")
  #   end
  # end
end