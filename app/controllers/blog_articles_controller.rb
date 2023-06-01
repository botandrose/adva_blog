class BlogArticlesController < ArticlesController
  def index
    articles

    if defined?(Comment)
      articles.includes!(:approved_comments_counter)
    end

    # set after articles are fetched
    @category ||= section.categories.build(title: "All Categories")

    if skip_caching? or stale?([site, section], public: true)
      respond_to do |format|
        format.html { render :template => "blogs/articles/index" }
        format.atom { render :template => "blogs/articles/index", :layout => false }
      end
    end
  end
end
