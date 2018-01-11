class Admin::HelpController < Admin::BaseController
  rescue_from ActionView::MissingTemplate, :with => :render_error_not_found
  after_action :verify_authorized, except: %i[index show article]

  def show
    page_url = params[:id]
    case page_url
    when 'opportunities'
      render 'admin/opportunities/help'
    when 'enquiries'
      render 'admin/enquiries/help'
    else
      render 'errors/not_found'
    end
  end

  def article
    article_id = normalise params[:id]
    article = "admin/help/%s" % [article_id]
    @article_path = "/%s" % [article] 
    @section_id = params[:section]
    render article
  end
  
  def normalise(str="")
    str.gsub "-", "_"
  end

  def render_error_not_found
    render "errors/not_found"
  end

end
