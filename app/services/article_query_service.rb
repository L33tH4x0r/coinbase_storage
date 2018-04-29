class ArticleQueryService
  class << self
    def query(params)
      @page_count = params[:page_count] || 100
      @page_count = @page_count.to_i

      @page       = params[:page] || 1
      @page       = @page.to_i

      @start      = params[:start]
      @end        = params[:end]

      unless params[:start] || params[:end]
        return get_all_articles
      else
        if params[:start] && params[:end]
          collection = Article.where("published_at >= ?", DateTime.parse(params[:start])).where("published_at <= ?", DateTime.parse(params[:end]))
        elsif params[:start]
          collection = Article.where("published_at >= ?", DateTime.parse(params[:start]))
        else
          collection = Article.where("published_at <= ?", DateTime.parse(params[:end]))
        end
        return create_response(collection)
      end
    end
    private
    def get_all_articles
      articles = Article.limit(@page_count).offset(@page_count*(@page-1))
      total = Article.count

      return_articles = get_return_articles(articles)


      return {
        total: total,
        page: @page,
        page_count: @page_count,
        current_count: get_current_count(return_articles),
        total_pages: get_total_pages(total),
        start: @start,
        end: @end,
        articles: return_articles
      }
    end

    def create_response(articles)
      return_articles = get_return_articles(articles)

      paginated_articles = paginate_articles(return_articles)

      return {total: return_articles.count,
              page: @page,
              page_count: @page_count,
              current_count: get_current_count(paginated_articles),
              total_pages: get_total_pages(paginated_articles.count),
              start: @start,
              end: @end,
              articles: paginated_articles}
    end

    def get_return_articles(articles)
      return_articles = []
      # Get all articles
      articles.each do |article|
        article_response = article.as_json
        article_response[:currencies] = []
        article.currencies.each do |currency|
          article_response[:currencies] << currency.as_json
        end
        article_response[:votes] = []
        article.votes.each do |vote|
          article_response[:votes] << vote.as_json
        end
        return_articles << article_response
      end
    end

    def paginate_articles(articles)

      start_index = (@page-1)*@page_count
      end_index   = @page*(@page_count)-1
      if end_index > articles.count
        end_index = -1
      end

      return articles[start_index .. end_index]
    end

    def get_current_count(articles)
      if articles
        articles.count
      else
        0
      end
    end

    def get_total_pages articles_count
      (articles_count.to_f / @page_count.to_f).ceil
    end
  end
end
