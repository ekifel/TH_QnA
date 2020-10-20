require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let(:service) { double('SphinxSearchService') }

  describe 'GET #search' do
    it 'return right data' do
      expect(SphinxSearchService).to receive(:new).and_return(service)
      expect(service).to receive(:call)

      get :search, params: { search: { section: 'all', q: 'test' } }
    end

    it 'render search page' do
      get :search, params: { search: { section: 'all', q: 'test' } }
      expect(response).to render_template :search
    end
  end

  describe 'search with empty request' do
    it 'returns success' do
      allow(SphinxSearchService).to receive(:new).and_return(service)
      allow(service).to receive(:call)

      get :search, params: { search: { section: 'all', q: '' } }
      expect(response).to render_template :search
    end
  end
end
