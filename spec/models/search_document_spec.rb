require 'rails_helper'

describe SearchDocument do
  describe '.for_nearests' do
    let!(:search_document_1) { FactoryBot.create(:search_document, content: 'cake of Ba Ngoai') }
    let!(:search_document_2) { FactoryBot.create(:search_document, content: 'noodles noodles and cake of 4P') }
    let!(:search_document_3) { FactoryBot.create(:search_document, content: 'pizza 4P') }
    let!(:search_document_4) { FactoryBot.create(:search_document, content: 'cake of Ba Noi') }
    let(:latitude) { -6.2189898 }
    let(:longitude) {106.7861758 }
    let(:coordinate) { Coordinate.new(latitude: latitude, longitude: longitude) }

    before do
      SearchDocument.update(latitude: latitude, longitude: longitude)
      search_document_4.update(latitude: 0, longitude: 0)
    end

    context 'no text' do
      it 'returns nearest search_documents within distance 50' do
        expect(SearchDocument.for_nearests(coordinate)).to match_array [search_document_1, search_document_2, search_document_3]
      end
    end

    context 'has text' do
      it 'returns nearest search_documents within distance 50 with matched text' do
        expect(SearchDocument.for_nearests(coordinate, text: 'cake')).to match_array [search_document_1, search_document_2]
      end
    end
  end

  describe '.for_bounds' do
    let!(:search_document_1) { FactoryBot.create(:search_document, content: 'cake of Ba Ngoai', latitude: 1, longitude: 1) }
    let!(:search_document_2) { FactoryBot.create(:search_document, content: 'noodles noodles and cake of 4P', latitude: 2, longitude: 2) }
    let!(:search_document_3) { FactoryBot.create(:search_document, content: 'pizza 4P', latitude: 4, longitude: 4) }
    let!(:search_document_4) { FactoryBot.create(:search_document, content: 'cake of Ba Noi', latitude: 11, longitude: 11) }
    let(:bounds) { [[0, 0], [5, 5]] }

    context 'no text' do
      it 'returns results in bounds' do
        expect(SearchDocument.for_bounds(bounds)).to match_array [search_document_1, search_document_2, search_document_3]
      end
    end

    context 'has text' do
      it 'returns results in bounds which is matching to text' do
        expect(SearchDocument.for_bounds(bounds, text: 'cake')).to match_array [search_document_1, search_document_2]
      end
    end
  end
end
