require 'rails_helper'

describe SearchDocumentQuery do
  let(:query) { SearchDocumentQuery.new(params) }
  let(:bounds) { [[0, 0], [1, 1]] }

  describe '.match_in_bounds' do
    context 'bounds params is empty' do
      let(:params) { {} }

      it 'returns none' do
        expect(query.match_in_bounds).to eq Location.none
      end
    end

    context 'bounds params is not empty' do
      let!(:search_document_1) { FactoryBot.create(:search_document, latitude: 0.5, longitude: 0.5, content: 'A') }
      let!(:search_document_2) { FactoryBot.create(:search_document, latitude: 1.5, longitude: 0.5, content: 'A 2') }
      let!(:search_document_3) { FactoryBot.create(:search_document, latitude: 0.5, longitude: 0.5, content: 'B') }

      context 'params does not contain query' do
        let(:params) { { bounds: bounds } }

        it 'returns match in bounds' do
          expect(query.match_in_bounds.to_a).to match_array [search_document_1, search_document_3]
        end
      end

      context 'otherwise' do
        let(:params) { { bounds: bounds, query: 'A' } }

        it 'returns match in bounds and match with query' do
          expect(query.match_in_bounds.to_a).to match_array [search_document_1]
        end
      end
    end
  end
end
