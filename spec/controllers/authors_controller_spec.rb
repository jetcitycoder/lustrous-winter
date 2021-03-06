require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  describe 'GET authors#index' do
    before do
      @author1 = FactoryGirl.create(:author)
      @author2 = FactoryGirl.create(:author)
      get :index
      json = JSON.parse(response.body)
      @author_ids = json.collect { |author| author['id'] }
    end

    it 'returns all authors in the response body' do
      expect(@author_ids).to eq([@author1.id, @author2.id])
    end

    it 'returns HTTP status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST authors#create' do
    context 'without errors' do
      before do
        post :create, params: { author: { first: 'First', last: 'Last' } }
        @author = Author.last
        @json = JSON.parse(response.body)
      end

      it 'saves a new author to the database' do
        expect(@author.first).to eq('First')
      end

      it 'returns the created author in the response body' do
        expect(@json['first']).to eq('First')
      end

      it 'returns HTTP status created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with errors' do
      before do
        post :create, params: { author: { first: '' } }
        @json = JSON.parse(response.body)
      end

      it 'returns errors in the response body' do
        expect(@json['errors']['first']).to eq(["can't be blank"])
      end

      it 'returns HTTP status unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH authors#update' do
    context 'without errors' do
      before do
        @author = FactoryGirl.create(:author)
        patch :update, params: { id: @author.id, author: { first: 'Updated' } }
        @author.reload
        @json = JSON.parse(response.body)
      end

      it 'saves updates to the database' do
        expect(@author.first).to eq('Updated')
      end

      it 'returns the updated author in the response body' do
        expect(@json['first']).to eq('Updated')
      end

      it 'returns HTTP status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with errors' do
      before do
        author = FactoryGirl.create(:author)
        patch :update, params: { id: author.id, author: { first: '' } }
        @json = JSON.parse(response.body)
      end

      it 'returns errors in the response body' do
        expect(@json['errors']['first']).to eq(["can't be blank"])
      end

      it 'returns HTTP status unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE authors#destroy' do
    context 'without errors' do
      before do
        @author = FactoryGirl.create(:author)
        delete :destroy, params: { id: @author.id }
      end

      it 'deletes the author from the databse' do
        expect(Author.find_by_id(@author.id)).to eq(nil)
      end

      it 'returns HTTP status no content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with errors' do
      before do
        delete :destroy, params: { id: 'no_id' }
      end

      it 'returns HTTP status not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
