module ApplicationHelper
  def heart_link(iphoto, c_user, size=nil)
    if size == :large
      if c_user 
        if c_user.likes?(iphoto) 
          image_tag('likeit.png') + link_to(image_tag('heart-icon-on.jpg', :id => 'myImage', :alt => 'like-stat-icon'), favorite_path(iphoto.id, :size => 'large'), :title=>"Click to unlike image", 'data-remote' => true) 
        else
          image_tag('likeit.png') + link_to(image_tag('heart-icon-off.jpg', :id => 'myImage', :alt => 'like-stat-icon'), favorite_path(iphoto.id, :size => 'large'), :title=>"Click to like image", 'data-remote' => true) 
        end
      else
        like_icon = 'heart-icon-off.jpg'
        image_tag('likeit.png') + image_tag(like_icon, :id => 'myImage', :alt => 'like-stat-icon', :title => 'SignIn to like image')
      end
    else
      if c_user
        like_icon = c_user.likes?(iphoto) ? 'like-stat-icon-on.jpg' : 'like-stat-icon.jpg'
        link_to(image_tag(like_icon, :id => 'myLikeIndex', :class => 'imgmiddle', :alt => 'like-stat-icon') +
        content_tag(:span, iphoto.fans.count, :class => 'vert'), favorite_path(iphoto.id), :title=>"Click to #{c_user.likes?(iphoto) ? 'unlike' : 'like'} image", 'data-remote' => true)
      else
        like_icon = 'like-stat-icon.jpg'
        image_tag(like_icon, :id => 'myLikeIndex', :class => 'imgmiddle', :alt => 'like-stat-icon', :title => 'SignIn to like image') +
        content_tag(:span, iphoto.fans.count, :class => 'vert')
      end
    end
  end

  def comment_link(iphoto, c_user)
    if c_user
      link_to(image_tag('comment-stat-icon.jpg', :class => 'imgmiddle', :alt => 'comment-stat-icon', :width => 16, :height => 15) +
      content_tag(:span, iphoto.comment_threads.count), "#{iphoto_path(iphoto)}#all_comments", :title => 'Leave a comment', :class => 'vert')
    else
      image_tag('comment-stat-icon.jpg', :class => 'imgmiddle', :alt => 'comment-stat-icon', :width => 16, :height => 15) +
      content_tag(:span, iphoto.comment_threads.count, :class => 'vert')
    end
  end

  def header_ad
    ad = AppConfiguration['ads']['header']
    image_tag ad[0], :alt => ad[1]
  end

  def listing_ad(section)
    ad = AppConfiguration['ads']['home_page'][section]
    link_to image_tag(ad[0], :alt => ad[1]), '#'
  end  

  def remove_comment(iphoto, comment)
    str = (image_tag 'cross.gif', :class=>'imgmiddle', :alt => 'delete comment') + content_tag(:span, 'delete comment', :class => "vert")
    link_to str, remove_comment_path(iphoto, comment), :method => :delete, 'data-remote' => true
  end

  def user_profile_link(user)
    user.class.to_s == "User" ? 'users/profile' : 'users/guest_info'
  end
end
