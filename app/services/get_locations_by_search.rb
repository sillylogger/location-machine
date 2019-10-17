class GetLocationsBySearch < Base
  attr_reader :search_documents, :locations

  def initialize(search_params = {})
    @search_params = search_params
  end

  def call
    @search_documents = SearchDocumentQuery.new(@search_params).match_in_bounds.includes(:searchable)
    @locations = Location.where(id: location_ids)
  end

  private

  def location_ids
    @search_documents.map do |document|
      if document.searchable_type == Location.to_s
        document.searchable_id
      else document.searchable_type == Item.to_s
        document.searchable&.location_id
      end
    end.compact.uniq
  end
end
