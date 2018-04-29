class ArticleQueryService
  class << self
    def query(params)
      @page_count = params[:page_count] || 100
      @page_count = @page_count.to_i

      @page       = params[:page] || 1
      @page       = @page.to_i

      @start = params[:start]
      @end = params[:end]

      unless params[:start] || params[:end]
        return create_response(get_all_articles, Article.count)
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
      Article.limit(@page_count).offset(@page_count*(@page-1))
    end

    def create_response(articles, total = nil)
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
      # paginate
      pagination = paginate_articles(return_articles)
      if pagination[:articles]
        current_count = pagination[:articles].count
      else
        current_count = 0
      end

      return {total: total || return_articles.count,
              page: @page,
              page_count: @page_count,
              current_count: current_count,
              total_pages: pagination[:total_pages],
              start: @start,
              end: @end,
              articles: pagination[:articles]}
    end

    def paginate_articles(articles)
      total_pages = (articles.count.to_f / @page_count.to_f).ceil
      pagination = {total_pages: total_pages}

      start_index = (@page-1)*@page_count
      end_index   = @page*(@page_count)-1
      if end_index > articles.count
        end_index = -1
      end

      pagination[:articles] = articles[start_index .. end_index]
      return pagination
    end
  end
end
