module ApplicationHelper
  def heart_link(iphoto, c_user)
    if c_user
      like_icon = c_user.likes?(iphoto) ? 'like-stat-icon-on.jpg' : 'like-stat-icon.jpg'
      link_to(image_tag(like_icon, :id => 'myLikeIndex', :class => 'imgmiddle', :alt => 'like-stat-icon') +
      content_tag(:span, iphoto.fans.count), favorite_path(iphoto.id), :title=>"Click to like image", 'data-remote' => true)
    else
      like_icon = 'like-stat-icon.jpg'
      image_tag(like_icon, :id => 'myLikeIndex', :class => 'imgmiddle', :alt => 'like-stat-icon') +
      content_tag(:span, count)
    end
  end

  def comment_link(iphoto, c_user)
    if c_user
      link_to(image_tag('comment-stat-icon.jpg', :class => 'imgmiddle', :alt => 'comment-stat-icon', :width => 16, :height => 15) +
      content_tag(:span, iphoto.comment_threads.count), iphoto_path(iphoto), :title => 'Leave a comment')
    else
      image_tag('comment-stat-icon.jpg', :class => 'imgmiddle', :alt => 'comment-stat-icon', :width => 16, :height => 15) +
      content_tag(:span, iphoto.comment_threads.count)
    end
  end
end
