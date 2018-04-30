class Poc::OpportunitiesController < OpportunitiesController
  prepend_view_path 'app/views/poc'

  FIELD_VALUES_WHY = %w[sample sell distribute use].freeze
  POC_OPPORTUNITY_PROPS = %w[what why need industry keywords value specifications respond_by respond_to link].freeze

  def index
    @content = get_content('opportunities/index.yml')
    @opportunity_summary_list = summary_list_by_industry
    @sort_column_name = sort_column
    @recent_opportunities = recent_opportunities
    @industries = industry_list
    render 'opportunities/index', layout: 'layouts/domestic'
  end

  def international
    render 'opportunities/international', layout: 'layouts/international'
  end

  def results
    @content = get_content('opportunities/results.yml')
    @filters = SearchFilter.new(params)
    @search_term = params['s']
    @sort_column_name = sort_column
    @industries = industry_list
    @subscription_form = subscription_form # Don't think we need this anymore
    @search_url = request.original_fullpath
    @search_results = opportunity_search
    @search_filters = {
      'sectors': search_filter_sectors,
      'countries': search_filter_countries,
    }
    render 'opportunities/results', layout: 'layouts/domestic'
  end

  def new
    @content = get_content('opportunities/new.yml')
    @process = {
      view: params[:view] || 'step_1',
      entries: {},
      errors: {},
    }

    # Record any user entries (not in DB at this point).
    process_add_user_entries

    # Reverse order is intentional.
    process_step_three
    process_step_two
    process_step_one

    if @process[:view] == 'complete'
      # TODO: Something to save opportunity in DB
      # and redirect to somewhere.
      redirect_to poc_international_path
    else
      render 'opportunities/new', layout: 'layouts/international'
    end
  end

  def show
    @opportunity = Opportunity.published.find(params[:id])
    render 'opportunities/show', layout: 'layouts/domestic'
  end

  private def process_add_user_entries
    POC_OPPORTUNITY_PROPS.each do |prop|
      @process[:entries][prop] = params[prop]
    end
  end

  private def process_step_one
    if @process[:view].eql? 'step_1'
      # TODO: Validate step_1 entries
      # If errors view should remain as step_1

      view = 'step_2'
      case @process[:entries]['what']
      when '1'
        content = 'step_2.1'
      when '2'
        content = 'step_2.2'
      when '3'
        content = 'step_2.3'
      when '4'
        content = 'step_2.4'
      else
        view = 'step_1'
        content = 'step_1'
      end

      @content = @content[content]
      @process[:view] = view
    end
  end

  private def process_step_two
    if @process[:view].eql? 'step_2'
      # TODO: Validate step_2 entries
      # If errors view should remain as step_2

      @content = @content['step_3']
      @process[:view] = 'step_3'
    end
  end

  private def process_step_three
    if @process[:view].eql? 'step_3'
      # TODO: Validate step_3 entries
      # If errors view should remain as step_3

      @process[:view] = 'complete' # TODO: Where/what?
    end
  end

  private def sort
    # set sort_order
    if @sort_column_name
      sort_order = @sort_column_name == 'response_due_on' ? 'asc' : 'desc'
    end

    if atom_request?
      OpportunitySort.new(default_column: 'updated_at', default_order: 'desc')
    else
      OpportunitySort.new(default_column: 'response_due_on', default_order: 'asc')
        .update(column: @sort_column_name, order: sort_order)
    end
  end

  private def sort_column
    # If user is using keyword to search
    if params.key?(:isSearchAndFilter) && params[:s].present?
      'relevance'
    # If user is filtering a search
    elsif params[:sort_column_name]
      params[:sort_column_name]
    else
      'response_due_on'
    end
  end

  private def opportunity_search
    per_page = Opportunity.default_per_page
    query = Opportunity.public_search(
      search_term: @search_term,
      filters: @filters,
      sort: sort
    )

    if atom_request?
      query = query.records
      query = query.page(params[:paged]).per(per_page)
      query = AtomOpportunityQueryDecorator.new(query, view_context)
      results = query
    else
      query = query.page(params[:paged]).per(per_page)
      results = query.records
    end

    {
      filters: @filters,
      results: results,
      total: query.records.total,
      limit: per_page,
      term: @search_term,
      sort_by: @sort_column_name,
    }
  end

  # Get 5 most recent only
  private def recent_opportunities
    per_page = 5
    query = Opportunity.public_search(
      search_term: nil,
      filters: SearchFilter.new,
      sort: OpportunitySort.new(default_column: 'updated_at', default_order: 'desc')
    )
    query = query.page(params[:paged]).per(per_page)
    {
      results: query.records,
      total: query.records.total,
      limit: per_page,
      sort_by: @sort_column_name,
    }
  end

  # TODO: How are the featured industries chosen?
  private def summary_list_by_industry
    # Food and drink    = id(14)
    # Retail and luxury = id(30)
    # Business and consumer services = id(4)
    # Software and computer srvices = id(32)
    # Creative and media = id(9)
    # Chemicals = id(5)

    @query = Sector.where(id: [14, 30, 4, 32, 9, 5])
  end

  private def industry_list
    @query = Sector.all
  end

  private def subscription_form
    SubscriptionForm.new(
      query: {
        search_term: @search_term,
        sectors: @filters.sectors,
        types: @filters.types,
        countries: @filters.countries,
        values: @filters.values,
      }
    )
  end

  private def search_filter_sectors
    # @filters.sectors ... lists all selected sectors
    # Sector.order(:name) ... lists all sectors in DB
    {
      'name': 'sectors[]',
      'options': Sector.order(:name),
      'selected': @filters.sectors,
    }
  end

  private def search_filter_countries
    # @filters.countries ... lists all selected countries
    # Country.order(:name) ... lists all countries in DB
    {
      'name': 'countries[]',
      'options': Country.order(:name),
      'selected': @filters.countries,
    }
  end
end
