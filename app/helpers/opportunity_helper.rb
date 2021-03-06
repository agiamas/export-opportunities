module OpportunityHelper
  def toggle_show_expired_link(label, show_expired:)
    show_expired = nil unless show_expired == true
    link_to label, session[:opportunity_filters].merge(show_expired: show_expired)
  end

  def opportunity_status_link(string)
    case string
    when 'publish' then 'Published'
    when 'trash' then 'Trashed'
    when 'pending' then 'Pending'
    when 'draft' then 'Draft'
    else
      string.to_s.titleize
    end
  end

  def filtered_admin_opportunities_path
    admin_opportunities_path(session[:opportunity_filters])
  end
end
