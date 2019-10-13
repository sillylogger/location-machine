require 'rails_helper'

describe GetLocationsBySearch do
  let(:service) { GetLocationsBySearch.call(params) }
  let(:bounds) { [[0, 0], [1, 1]] }
  let(:params) { { bounds: bounds, query: 'A' } }
  let!(:search_document_1) { FactoryBot.create(:search_document, :item, latitude: 0.5, longitude: 0.5, content: 'A') }
  let!(:search_document_2) { FactoryBot.create(:search_document, :location, latitude: 1.5, longitude: 0.5, content: 'A 2') }
  let!(:search_document_3) { FactoryBot.create(:search_document, :item, latitude: 0.5, longitude: 0.5, content: 'B') }
  let!(:search_document_4) { FactoryBot.create(:search_document, :location, latitude: 0.5, longitude: 0.5, content: 'A 3') }

  describe '#call' do
    it 'excute service and be able to get locations, search_documents' do
      expect(service.search_documents).to match_array [search_document_1, search_document_4]
      expect(service.locations.map(&:id)).to match_array [search_document_1.searchable.location_id, search_document_4.searchable_id]
    end
  end
end
