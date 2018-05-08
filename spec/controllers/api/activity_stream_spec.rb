require 'rails_helper'

RSpec.describe Api::ActivityStreamController, type: :controller do
  describe 'GET feed controller' do
    it 'responds with a blank JSON object' do
      get :index, params: { format: :json }

      expect(response.body).to eq('{}')
    end
  end
end
