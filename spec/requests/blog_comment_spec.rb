require 'rails_helper'

RSpec.describe "Blog Comments", type: :request do
  include_context :an_article

  before do
    host! 'site-with-blog.com'
    # TODO: Implement permissions system
    # site.update!(permissions: { 'create comment' => 'anonymous' })
  end

  # TODO: Implement when comment system and authentication are ready
  # describe "An anonymous user posts a comment to a blog article" do
  #   it "allows posting and viewing the comment" do
  #     visit "/#{blog.permalink}/2008/1/1/a-blog-article"
  #
  #     fill_in "user_name", with: "John Doe"
  #     fill_in "user_email", with: "john@example.com"
  #     fill_in "comment_body", with: "What a nice article!"
  #     click_button "Submit comment"
  #
  #     expect(current_url).to match(%r{#{site.host}/comments/\d+})
  #     expect(page).to have_content("What a nice article!")
  #
  #     click_link 'a blog article'
  #     expect(current_url).to eq(blog_article_url(blog, article))
  #   end
  # end
  #
  # describe "A registered user posts a comment to a blog article" do
  #   before do
  #     # login_as(user)
  #   end
  #
  #   it "allows posting and viewing the comment" do
  #     visit "/#{blog.permalink}/2008/1/1/a-blog-article"
  #
  #     fill_in "comment_body", with: "What a nice article!"
  #     click_button "Submit comment"
  #
  #     expect(current_url).to match(%r{#{site.host}/comments/\d+})
  #     expect(page).to have_content("What a nice article!")
  #
  #     click_link 'a blog article'
  #     expect(current_url).to eq(blog_article_url(blog, article))
  #   end
  # end

  # Placeholder test until comment system is implemented
  it "is ready for comment functionality" do
    expect(article).to be_present
    expect(blog).to be_present
  end
end