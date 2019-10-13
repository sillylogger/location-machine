require 'rails_helper'

describe LocationQuery do
  let(:query) { LocationQuery.new(params) }
  let(:bounds) { [[0, 0], [1, 1]] }

  describe '#match_in_bounds' do
    context 'bounds params is empty' do
      let(:params) { {} }

      it 'returns none' do
        expect(query.match_in_bounds).to eq Location.none
      end
    end

    context 'bounds params is not empty' do
      let!(:location_1) { FactoryBot.create(:location, latitude: 0.5, longitude: 0.5, name: 'A') }
      let!(:location_2) { FactoryBot.create(:location, latitude: 1.5, longitude: 0.5, name: 'A 2') }
      let!(:location_3) { FactoryBot.create(:location, latitude: 0.5, longitude: 0.5, name: 'B') }

      context 'params does not contain query' do
        let(:params) { { bounds: bounds } }

        it 'returns match in bounds' do
          expect(query.match_in_bounds.to_a).to match_array [location_1, location_3]
        end
      end

      context 'otherwise' do
        let(:params) { { bounds: bounds, query: 'A' } }

        it 'returns match in bounds and match with query' do
          expect(query.match_in_bounds.to_a).to match_array [location_1]
        end
      end
    end
  end
end
