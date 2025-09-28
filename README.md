Adva Blog
===========

Adva Blog is the blog component for the Adva CMS. It ships as a Rails Engine that plugs into an Adva-powered Rails application and provides everything needed to run a blog:

- A `Blog` section type with article listings, archives, categories, and tags
- Public controllers, helpers, and views for listing and showing articles
- Admin controllers and views to manage blog articles and categories
- Atom feeds for the blog, categories, and tags
- Date-based, permalink-style URLs for individual articles

This README focuses on the functionality exposed by the engine so developers can install, integrate, and extend it.


Requirements
------------

- Ruby and Rails compatible with your Adva CMS installation (tested with Rails ~> 7.2).
- The `adva` gem (core CMS). Adva Blog depends on Adva models like `Section`, `Article`, `Category`, `Site`, and optionally `Comment`.


Installation
------------

Add to your application’s `Gemfile` alongside Adva:

```ruby
gem 'adva'
gem 'adva_blog'
```

Then install:

```bash
bundle install
```

No manual mounting is required. The engine registers itself and adds a `Blog` section type to Adva at boot via:

```ruby
::Section.register_type 'Blog'
```

Create a Blog section through the Adva admin UI. Once created, the public blog frontend becomes available under the section’s permalink (for example, `/a-blog`).


Key Concepts
------------

- Blog section: A specialized `Section` that contains `Article` content. In code it’s the `Blog` model, which inherits from `Section` and aliases `contents` to `articles`.
- Articles: Standard Adva `Article` records associated to a blog via `section_id`.
- Categories: Hierarchical `Category` taxonomy scoped to the blog.
- Tags: Free-form tagging on articles (when tags are enabled in Adva).
- Comments: Optional. If a `Comment` model is present, comment counts and feeds are wired up.


Public Interface
----------------

Controllers
- `BlogArticlesController < ArticlesController`:
  - `index`: Lists articles for a blog, scoped by optional category, tags, and archive parameters. Renders `blogs/articles/index` (HTML or Atom).
  - `show`: Displays a single article at a date-based permalink and renders `blogs/articles/show`.

Routing and URLs
- Blog index: `blog_path(section)` → `/a-blog`
- Archives: `blog_path(section, year: '2008', month: '1')` → `/a-blog/2008/1`
- Category index: `blog_category_path(section, category)` → `/a-blog/categories/a-category`
- Tag index: `blog_tag_path(section, 'foo+bar')` → `/a-blog/tags/foo+bar`
- Article show (date permalink): `blog_article_path(section, article)` → `/a-blog/2008/1/1/a-blog-article`
- Feeds (Atom):
  - Blog: `blog_path(section, format: :atom)` → `/a-blog.atom`
  - Category: `blog_category_path(section, category, format: :atom)` → `/a-blog/categories/a-category.atom`
  - Tag: `blog_tag_path(section, 'foo+bar', format: :atom)` → `/a-blog/tags/foo+bar.atom`

Helpers
- `BlogHelper#articles_title(category = nil, tags = nil, month = nil, format: nil)`
  - Builds a contextual page title like: `"Articles from January 2008, about a category, tagged foo and bar"`.
  - Pass `format: '<h2 class="list_header">%s</h2>'` to wrap the result.
- `BlogHelper#archive_month(year:, month:)` → `Time`
  - Converts year/month params into a `Time` for archive filters.
- `BlogHelper#blog_article_path(section, article)` / `#blog_article_url(section, article)`
  - Yields a date-based permalink for published articles; falls back to unpublished paths otherwise.
- `BlogHelper#absolutize_links(html)`
  - Rewrites `href="/…"` and `src="/…"` to absolute URLs based on the current site; used when building feeds.

Views
- Public views (ERB):
  - `blogs/articles/index.html.erb` – Article list with category/tag/archive context and footer.
  - `blogs/articles/show.html.erb` – Single article view with optional comments.
  - `blogs/articles/_article.html.erb` – Shared article partial (list and single modes).
  - `blogs/articles/_footer.html.erb` – Categories and archive links; feed link.
  - `blogs/articles/index.atom.builder` – Atom feed for articles (blog, category, tag).


Admin Interface
---------------

- `Admin::BlogsController < Admin::SectionsController` – Manage the Blog section.
- `Admin::Blog::ArticlesController < Admin::Page::ArticlesController` – Manage articles within a blog.
- `Admin::Blog::CategoriesController < Admin::Page::CategoriesController` – Manage blog categories.
- `Admin::Blog::ContentsController < Admin::Page::ContentsController` – Redirects to blog articles.
- Settings partial: `admin/sections/settings/_blog.html.erb` – Adds blog settings such as `contents_per_page` to the section settings form.


Model API
---------

The `Blog` model exposes convenience methods for archives and navigation:

```ruby
class Blog < Section
  has_many :articles, -> { order('contents.published_at DESC') }, foreign_key: :section_id, dependent: :destroy
  alias_method :contents, :articles

  def self.content_types
    %w(Article)
  end

  def archive_months
    article_counts_by_month.transpose.first
  end

  def article_counts_by_month
    articles_by_month.map { |month, list| [month, list.size] }
  end

  def articles_by_year
    @articles_by_year ||= articles.published.group_by(&:published_year)
  end

  def articles_by_month
    @articles_by_month ||= articles.published.group_by(&:published_month)
  end

  def nav_children
    categories.roots
  end
end
```

Use these to build archive navigation, sidebars, or custom views.


Behavioral Notes
----------------

- Comments: If a `Comment` model is defined, the blog index includes approved comment counts and the show page renders comments and a comment form when `accept_comments?` is true.
- Caching: Public actions use ETag/Last-Modified via Rails’ `stale?` and can be integrated with HTTP caches. Adva core also applies page caching helpers.
- I18n and paths: Adva’s URL helpers can include locale prefixes and root-section logic; Adva Blog participates in that routing.


Customization
-------------

- Views: Copy any view from `app/views/blogs` or `app/views/admin` into your app to override.
- Helpers: Extend `BlogHelper` in your app to tweak title formats or URL behavior.
- Controllers: Subclass the provided controllers or use `prepend_before_action`/`around_action` hooks in your app to inject behavior.


Getting Started Example
-----------------------

Once you’ve created a Blog section in the admin UI, you can link to it and to its article routes from anywhere in your app:

```erb
<%# Link to the blog index %>
<%= link_to 'Blog', blog_path(@blog) %>

<%# Link to a category %>
<%= link_to @category.title, blog_category_path(@blog, @category) %>

<%# Link to archives %>
<%= link_to 'Jan 2008', blog_path(@blog, year: 2008, month: 1) %>

<%# Link to an article (date-based permalink) %>
<%= link_to @article.title, blog_article_path(@blog, @article) %>
```


Development
-----------

This gem includes a dummy Rails app and RSpec test suite.

Run the tests:

```bash
bundle install
bundle exec rspec
```

Coverage is tracked via SimpleCov and outputs HTML under `coverage/`.


Compatibility
-------------

- Rails: developed against Rails ~> 7.2 for specs.
- Adva: requires the `adva` gem and its models. Comments, tags, and some helpers are enabled when the corresponding Adva components are present.


License
-------

MIT. See `LICENSE`.


Contributing
------------

Pull requests are welcome. For larger changes, please open an issue first to discuss what you’d like to change.

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/my-change`
3. Run and extend tests: `bundle exec rspec`
4. Commit with clear messages
5. Open a PR with context on the change and rationale
