class SearchDocumentQuery
  def initialize(params = {}, scoped = SearchDocument)
    @scoped = scoped
    @params = params
  end

  def match_in_bounds
    if @params[:bounds].present?
      @scoped = @scoped.in_bounds(@params[:bounds])
      @scoped = @scoped.search_for(@params[:query]) if @params[:query].present?
      @scoped = @scoped.limit(Setting.site_limit_location)
    else
      @scoped = @scoped.none
    end
    @scoped
  end
end
