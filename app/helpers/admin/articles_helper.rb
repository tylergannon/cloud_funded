module Admin::ArticlesHelper
  def editable
    {data: {mercury: :full}}
  end
  def published_at(article)
    if article.published_at
      article.published_at.strftime("%b %d, %Y")
    else
      "Not published."
    end
  end
end
