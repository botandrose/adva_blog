RSpec.shared_context :a_blog do
  let!(:site) { Site.create!(name: 'site with blog', title: 'site with blog title', host: 'site-with-blog.com') }
  let!(:blog) { Blog.create!(site: site, title: 'a blog', permalink: 'a-blog', comment_age: 0, published_at: Time.parse('2008-01-01 12:00:00')) }
  let(:section) { blog }

  before do
    @section = blog
    @site = site
    # set_request_host! - TODO: implement if needed
  end
end

RSpec.shared_context :a_category do
  include_context :a_blog
  let!(:category) { Category.create!(section: blog, title: 'a category') }

  before do
    @category = category
  end
end

RSpec.shared_context :an_article do
  include_context :a_blog
  include_context :a_category
  let!(:user) { User.create!(first_name: 'a user', email: 'user@example.com', password: 'SecurePassword123!') }
  let!(:article) do
    Article.create!(
      site: site,
      section: blog,
      title: 'a blog article',
      body: 'a blog article body',
      categories: [category],
      tag_list: 'foo bar',
      author: user,
      published_at: Time.parse('2008-01-01 12:00:00')
    )
  end

  before do
    @article = article
    @user = user
  end
end

RSpec.shared_context :default_routing_filters do
  # TODO: Implement when routing filters are added to the application
end

RSpec.shared_context :article_has_an_excerpt do
  before do
    article.update!(excerpt: 'article excerpt')
  end
end

RSpec.shared_context :article_has_no_excerpt do
  before do
    article.update!(excerpt: nil)
  end
end

RSpec.shared_context :comments_or_commenting_allowed do
  # TODO: Implement when comment system is added
end

RSpec.shared_context :no_comments_and_commenting_not_allowed do
  # TODO: Implement when comment system is added
end

RSpec.shared_context :the_article_is_published do
  before do
    article.update!(published_at: Time.parse('2008-01-01 12:00:00'))
  end
end

RSpec.shared_context :default_theme do
  # TODO: Implement when theme system is added
end