module ApplicationHelper
  def format_money(cents)
    sprintf("$%0.2f", cents.to_f/100)
  end
end
