require 'rails_helper'

RSpec.describe "Admin Blog Article", type: :request do
  include_context :an_article

  before do
    host! 'site-with-blog.com'
    # TODO: Implement time stubbing when needed
    # allow(Time).to receive(:now).and_return(Time.utc(2008, 1, 1))
  end

  # TODO: Implement when admin authentication and UI are ready
  # describe "Admin creates an article, previews, edits and deletes it" do
  #   before do
  #     login_as_admin
  #   end
  #
  #   it "allows full article management workflow" do
  #     # Visit admin articles index
  #     visit "/admin/sites/#{site.id}/sections/#{blog.id}/articles"
  #
  #     # Create new article
  #     click_link "New"
  #     fill_in 'article[title]', with: 'the article title'
  #     fill_in 'article[body]', with: 'the article body'
  #     click_button 'Save'
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/\d+/articles/\d+/edit})
  #
  #     # Revise the article
  #     fill_in 'article[title]', with: 'the revised article title'
  #     fill_in 'article[body]', with: 'the revised article body'
  #     click_button 'Save'
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/\d+/articles/\d+/edit})
  #     back_url = current_url
  #
  #     # Preview article
  #     click_link 'Show'
  #     new_article = Article.find_by(permalink: 'the-article-title')
  #     expect(current_url).to eq(blog_article_url(blog, new_article))
  #
  #     # Delete article
  #     visit back_url
  #     click_link 'Delete'
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/\d+/articles})
  #     expect(page).not_to have_content('the revised article title')
  #   end
  # end

  # Placeholder test until admin system is implemented
  it "has article available for admin management" do
    expect(article).to be_present
    expect(blog).to be_present
    expect(site).to be_present
  end
end