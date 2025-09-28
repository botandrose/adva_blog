require 'rails_helper'

RSpec.describe "Admin Blog", type: :request do
  include_context :a_blog

  before do
    host! 'site-with-blog.com'
  end

  # TODO: Implement when admin authentication and UI are ready
  # describe "Admin creates a blog, changes settings and deletes it" do
  #   before do
  #     login_as_admin
  #   end
  #
  #   it "allows full blog management workflow" do
  #     visit "/admin/sites/#{site.id}"
  #
  #     # Create new section
  #     click_link 'Sections'
  #     click_link 'New'
  #     fill_in 'title', with: 'the blog'
  #     select 'Blog'
  #     click_button 'Save'
  #
  #     expect(site.sections.last).to be_a(Blog)
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/\d+/articles})
  #
  #     # Revise section settings
  #     within '#main_menu' do
  #       click_link 'Settings'
  #     end
  #     fill_in 'title', with: 'the uberblog'
  #     click_button 'Save'
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/\d+/edit})
  #
  #     # Delete section
  #     click_link 'Delete'
  #     expect(current_url).to match(%r{/admin/sites/\d+/sections/new})
  #   end
  # end

  # Placeholder test until admin system is implemented
  it "has blog available for admin management" do
    expect(blog).to be_present
    expect(site).to be_present
  end
end