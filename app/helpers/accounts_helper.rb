module AccountsHelper
  def amount_css_class(transaction)
    a = {}
    if transaction.amount < 0
      a[:class] = 'negative'
    end
    a
  end
end
