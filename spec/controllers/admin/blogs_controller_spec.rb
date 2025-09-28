require 'rails_helper'

RSpec.describe Admin::BlogsController, type: :controller do
  include_context :a_blog

  describe "inheritance" do
    it "inherits from Admin::SectionsController" do
      expect(described_class.superclass.name).to eq("Admin::SectionsController")
    end
  end
end