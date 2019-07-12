require 'rails_helper'

describe SearchDocument do
  describe '.for_nearests' do
    let!(:search_document_1) { FactoryBot.create(:search_document, content: 'cake of Ba Ngoai') }
    let!(:search_document_2) { FactoryBot.create(:search_document, content: 'noodles noodles and cake of 4P') }
    let!(:search_document_3) { FactoryBot.create(:search_document, content: 'pizza 4P') }
    let!(:search_document_4) { FactoryBot.create(:search_document, content: 'cake of Ba Noi') }
    let(:latitude) { -6.2189898 }
    let(:longitude) {106.7861758 }

    before do
      SearchDocument.update(latitude: latitude, longitude: longitude)
      search_document_4.update(latitude: 0, longitude: 0)
    end

    context 'no text' do
      it 'returns nearest search_documents within distance 50' do
        expect(SearchDocument.for_nearests([latitude, longitude])).to match_array [search_document_1, search_document_2, search_document_3]
      end
    end

    context 'has text' do
      it 'returns nearest search_documents within distance 50 with matched text' do
        expect(SearchDocument.for_nearests([latitude, longitude], text: 'cake')).to match_array [search_document_1, search_document_2]
      end
    end
  end
end
