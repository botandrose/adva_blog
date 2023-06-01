class BlogArticlesController < ArticlesController
  def index
    if @section.categories.any?
      @category ||= @section.categories.build(title: "All Categories", contents: @articles) 
    end
    if skip_caching? or stale?(:etag => @section, :last_modified => [@articles.to_a, @section, @site].flatten.collect(&:updated_at).compact.max.utc, :public => true)
      respond_to do |format|
        format.html { render :template => "blogs/articles/index" }
        format.atom { render :template => "blogs/articles/index", :layout => false }
      end
    end
  end

  public

  def set_articles
    super
    @articles.includes!(:approved_comments_counter) if defined?(Comment)
  end
end
