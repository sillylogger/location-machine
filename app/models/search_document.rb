class SearchDocument < PgSearch::Document
  include PgSearch

  attr_accessor :distance

  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  pg_search_scope :search_for, against: %i(content)

  scope :for_nearests, -> (coordinate, text: '', distance: Setting.site_location_radius) {
    latlng = coordinate.to_latlng
    scoped = within(distance, origin: latlng).by_distance(origin: latlng)
    scoped = scoped.search_for(text) if text.present?
    scoped
  }
end
