module BlogHelper
  def articles_title(*args)
    options = args.extract_options!
    category, tags, month = *args
    month = archive_month(month) if month && !month.is_a?(Time)

    title = []
    title << "from #{month.strftime('%B %Y')}" if month
    title << "about #{category.title}" if category
    title << "tagged #{tags.to_sentence}" if tags
    
    if title.present?
      title = "Articles #{title.join(', ')}"
      options[:format] ? raw(options[:format]) % title : title
    end
  end

  def archive_month(params = {})
    Time.local(params[:year], params[:month]) if params[:year]
  end

  def blog_article_path section, article, options={}
    if article.published_at
      super :section_permalink => section.permalink,
        :year => article.published_at.year,
        :month => article.published_at.month,
        :day => article.published_at.day,
        :permalink => article.permalink
    else
      unpublished_blog_article_path section, article
    end
  end

  def blog_article_url section, article, options={}
    if article.published_at
      super :section_permalink => section.permalink,
        :year => article.published_at.year,
        :month => article.published_at.month,
        :day => article.published_at.day,
        :permalink => article.permalink
    else
      unpublished_blog_article_url section, article
    end
  end

  def absolutize_links html
    html.gsub /(href|src)="\//, %(\\1="http://#{@site.host}/)
  end
end
