require 'rails_helper'

RSpec.describe Admin::Blog::CategoriesController, type: :controller do
  include_context :a_blog

  describe "inheritance" do
    it "inherits from Admin::Page::CategoriesController" do
      expect(described_class.superclass.name).to eq("Admin::Page::CategoriesController")
    end
  end
end

