require "active_support/core_ext/time"

if Site.count.zero?
  site = Site.create!(name: "site with blog", title: "site with blog title", host: "site-with-blog.com")

  blog = Blog.create!(site: site, title: "a blog", permalink: "a-blog", comment_age: 0, published_at: Time.parse('2008-01-01 12:00:00'))
  category = Category.create!(section: blog, title: "a category")
  Category.create!(section: blog, title: "another category")

  user = User.create!(first_name: "a user", email: "a-user@example.com", password: "AAbbcc1122!!", verified_at: Time.now)
  admin = User.create!(first_name: "an admin", email: "admin@example.com", password: "AAbbcc1122!!", verified_at: Time.now)
  moderator = User.create!(first_name: "a moderator", email: "moderator@example.com", password: "AAbbcc1122!!", verified_at: Time.now)

  Article.create!(
    site: site,
    section: blog,
    title: "a blog article",
    body: "a blog article body",
    categories: [category],
    tag_list: "foo bar",
    author: user,
    published_at: Time.parse('2008-01-01 12:00:00')
  )

  Article.create!(
    site: site,
    section: blog,
    title: "an unpublished blog article",
    body: "an unpublished blog article body",
    categories: [category],
    tag_list: "foo bar",
    author: user
  )

  # Create admin and moderator roles if Role model exists
  if defined?(Role)
    admin.roles.create!(name: "admin", context: site) if admin.respond_to?(:roles)
    moderator.roles.create!(name: "moderator", context: blog) if moderator.respond_to?(:roles)
  end
end