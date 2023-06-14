require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'GET /users/new' do
    it 'renders the new template' do
      get new_user_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('User Registration Form')
      expect(response.body).to include('Full name')
      expect(response.body).to include('Email')
      expect(response.body).to include('Password')
      expect(response.body).to include('Country Code')
      expect(response.body).to include('Password')
      expect(response.body).to include('Register')
    end

  end

  describe 'POST /users' do
    context "with valid attributes" do
      before(:each) do
        @articles = [
          {
            source: { id: 'associated-press', name: 'Associated Press' },
            author: 'Susie Blann',
            title: 'Russian private army head claims control of Bakhmut but Ukraine says fighting continues - The Associated Press',
            description: 'KYIV, Ukraine (AP) — The head of the Russian private army Wagner claimed Saturday that his forces have taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukraine war, but Ukrainian defense officials denied it.',
            url: 'https://apnews.com/article/bakhmut-russia-ukraine-wagner-prigozhin-da2fc05b818b3dcc39decd40b17d2d8b',
            url_to_image: 'https://storage.googleapis.com/afs-prod/media/8dd9fdbbef9d4727a480b275e08fe599/2879.webp',
            publish_at: '2023-05-20T15:37:42Z',
            content: 'KYIV, Ukraine (AP) The head of the Russian private army Wagner claimed Saturday that his forces have taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukra… [+4383 chars]'
          },
          {
            source: { id: nil, name: 'POLITICO.eu' },
            author: 'Ashleigh Furlong',
            title: "Russia warns West sending F-16s to Ukraine 'carries enormous risks': TASS - POLITICO Europe",
            description: "Kyiv has pushed its allies to supply modern combat aircraft for Ukraine’s defense against the Russian invasion.",
            url: 'https://www.politico.eu/article/russia-alexander-grushko-warns-west-f16-jets-ukraine-carries-enormous-risks-tass/',
            url_to_image: 'https://www.politico.eu/cdn-cgi/image/width=1200,height=630,fit=crop,quality=80,onerror=redirect/wp-content/uploads/2023/05/20/GettyImages-1488520640-scaled.jpg',
            publish_at: '2023-05-20T15:22:00Z',
            content: 'The Wests effort to potentially send modern fighter jets to Ukraine carries enormous risks, Russias Deputy Foreign Minister Alexander Grushko warned on Saturday, according to Russian state news agenc… [+1050 chars]'
          },
        ]

        allow_any_instance_of(NewsApi).to receive(:call).and_return(@articles)

        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes }
      end

      it "creates a new user" do
        new_record = User.last
        expect(User.count).to eq(1)
      end

      it "redirects to the correct path" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response" do
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('User successfully registered')
      end
    end

    context "with invalid attributes" do
      it "returns an error for blank name" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: '') }

        expect(User.count).to eq(0)
        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "returns an error for blank email" do
        user_attributes = FactoryBot.attributes_for(:user, email: '')
        post users_path, params: { user: user_attributes }

        expect(User.count).to eq(0)
        expect(response.body).to include("Email can&#39;t be blank")
      end

      it "returns an error for password shorter than 6 characters" do
        user_attributes = FactoryBot.attributes_for(:user, password: '')
        post users_path, params: { user: user_attributes }

        expect(User.count).to eq(0)
        expect(response.body).to include("Password is too short")
      end

      it "returns an error for blank country code" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(country_code: '') }

        expect(User.count).to eq(0)
        expect(response.body).to include("Country code can&#39;t be blank")
      end

    end

  end
end
