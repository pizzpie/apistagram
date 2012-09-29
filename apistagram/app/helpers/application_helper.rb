module ApplicationHelper
  def heart_link(like_icon, count)
    image_tag(like_icon, :id => 'myLikeIndex', :class => 'imgmiddle', :alt => 'like-stat-icon') +
    content_tag(:span, count)
  end
end
