require 'rails_helper'

RSpec.describe "Blog Counter", type: :model do
  include_context :an_article

  let(:blog_with_counter) { blog }
  let(:test_article) { article }

  # Counter functionality is provided by the optional adva_comments gem
  # Skip these tests if Comment is not defined
  if defined?(Comment)
    describe "associations" do
      it "has_one comments_counter" do
        expect(blog_with_counter).to respond_to(:comments_counter)
      end
    end

    describe "methods" do
      it "responds to :comments_count" do
        expect(blog_with_counter).to respond_to(:comments_count)
      end

      it "has a counter initialized and saved after create" do
        expect(blog_with_counter.comments_counter).not_to be_nil
      end

      it "#comments_count is a shortcut to #comments_counter.count" do
        blog_with_counter.comments_counter.update!(count: 5)
        expect(blog_with_counter.comments_count).to eq(5)
      end
    end

    describe "counter increments and decrements" do
      let(:create_comment!) do
        blog_with_counter.comments.create!(
          section: blog_with_counter,
          body: 'body',
          author: user,
          commentable: test_article
        )
      end

      it "increments the counter when a comment has been created" do
        expect { create_comment! }.to change { blog_with_counter.comments_counter.reload.count }.by(1)
      end

      it "decrements the counter when a comment has been destroyed" do
        comment = create_comment!
        expect { comment.destroy }.to change { blog_with_counter.comments_counter.reload.count }.by(-1)
      end
    end
  else
    it "skips counter tests when Comment is not defined (adva_comments gem not available)" do
      expect(defined?(Comment)).to be_falsey
    end
  end
end