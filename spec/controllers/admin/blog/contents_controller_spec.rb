require 'rails_helper'

RSpec.describe Admin::Blog::ContentsController, type: :controller do
  include_context :a_blog

  describe "inheritance" do
    it "inherits from Admin::Page::ContentsController" do
      expect(described_class.superclass.name).to eq("Admin::Page::ContentsController")
    end
  end

  describe "GET #index" do
    before do
      controller.instance_variable_set(:@section, blog)
    end

    it "redirects to admin section articles" do
      expect(controller).to receive(:redirect_to).with([:admin, blog, :articles])
      controller.index
    end
  end
end

