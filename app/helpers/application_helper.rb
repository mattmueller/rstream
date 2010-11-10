module ApplicationHelper
  include Twitter::Autolink

  def twitter_link(content)
    raw(auto_link(content))
  end
end
