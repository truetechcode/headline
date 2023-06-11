require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /sessions' do
    let(:user) { {name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password', country_code: 'us'} }

    context 'with valid credentials' do
      before do
        User.create! user
        post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets a success notice' do
        expect(flash[:success]).to eq('Logged in successfully.')

        follow_redirect!

        expect(response.body).to include('Logged in successfully.')
      end
    end

    context 'with invalid credentials' do
      before do
        User.create! user
        post sessions_path, params: { session: {email: 'user@example.com', password: ''} }
      end

      it 'sets an alert flash message' do
        expect(response.body).to include('Invalid email or password.')
      end
    end
  end

  describe 'DELETE /sessions' do
    let(:user) { create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password', country_code: 'us') }

      before(:each) do
        post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
        delete session_path(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash notice message' do
        expect(flash[:success]).to eq('Logged out successfully.')
      end
    end
end
