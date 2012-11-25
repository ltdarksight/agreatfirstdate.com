class WpLinkRenderer < WillPaginate::ActionView::LinkRenderer
  WillPaginate::ViewHelpers.pagination_options[:class] = 'navigation'
  WillPaginate::ViewHelpers.pagination_options[:previous_label] = 'Newer posts &#8594;'
  WillPaginate::ViewHelpers.pagination_options[:next_label] = '&#8592; Older posts'
  
  def to_html
    html_container(next_page + previous_page)
  end
  
protected
  def previous_or_next_page(page, text, classname)
    if page
      tag(:div, link(text, page), :class => classname)
    else
      ''
    end
  end
end
