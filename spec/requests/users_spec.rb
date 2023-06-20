# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "GET /users/new" do
    it "returns a success response" do
      get new_user_path

      expect(response).to have_http_status(:success)
    end

    it "renders the new template with 'User Registration Form'" do
      get new_user_path

      expect(response.body).to include("User Registration Form")
    end

    it "renders the new template with 'Full name'" do
      get new_user_path

      expect(response.body).to include("Full name")
    end

    it "renders the new template with 'Register'" do
      get new_user_path

      expect(response.body).to include("Register")
    end
  end

  describe "POST /users" do
    context "with valid attributes" do
      let(:articles) do
        [
          {
            source: { id: "associated-press", name: "Associated Press" },
            author: "Susie Blann",
            title: "Russian private army head claims control of Bakhmut but Ukraine says fighting continues - The Associated
           Press",
            description: "KYIV, Ukraine (AP) — The head of the Russian private army Wagner claimed Saturday that his forces
          have taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukraine war,
          but Ukrainian defense officials denied it.",
            url: "https://apnews.com/article/bakhmut-russia-ukraine-wagner-prigozhin-da2fc05b818b3dcc39decd40b17d2d8b",
            url_to_image: "https://storage.googleapis.com/afs-prod/media/8dd9fdbbef9d4727a480b275e08fe599/2879.webp",
            publish_at: "2023-05-20T15:37:42Z",
            content: "KYIV, Ukraine (AP) The head of the Russian private army Wagner claimed Saturday that his forces have
           taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukra…"
          },
          {
            source: { id: nil, name: "POLITICO.eu" },
            author: "Ashleigh Furlong",
            title: "Russia warns West sending F-16s to Ukraine 'carries enormous risks': TASS - POLITICO Europe",
            description: "Kyiv has pushed its allies to supply modern combat aircraft for Ukraine’s defense against the
          Russian invasion.",
            url: "https://www.politico.eu/article/russia-alexander-grushko-warns-west-f16-jets-ukraine-carries-enormous-risks-tass/",
            url_to_image: "https://www.politico.eu/cdn-cgi/image/width=1200,height=630,fit=crop,quality=80,onerror=redirect/wp-content/uploads/2023/05/20/GettyImages-1488520640-scaled.jpg",
            publish_at: "2023-05-20T15:22:00Z",
            content: "The Wests effort to potentially send modern fighter jets to Ukraine carries enormous risks, Russias
          Deputy Foreign Minister Alexander Grushko warned on Saturday, according to Russian state news agenc…"
          }
        ]
      end
      let(:instance) { NewsApi.new("us") }

      before do
        stub_request(:get, "https://newsapi.org/v2/top-headlines?apiKey=#{ENV.fetch('NEWSAPI_KEY', nil)}&country=us")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(
            status: 200,
            body: {
              status: "ok",
              totalResults: 0,
              articles:
            }.to_json,
            headers: { "Content-Type": "application/json" }
          )

        allow(instance).to receive(:call).and_return(articles)

        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes }
      end

      it "creates a new user" do
        User.last
        expect(User.count).to eq(1)
      end

      it "have http status redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it "redirects to the correct path" do
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response" do
        follow_redirect!
        expect(response.body).to include("User successfully registered")
      end
    end

    context "with invalid attributes" do
      it "does not increment User count" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: "") }

        expect(User.count).to eq(0)
      end

      it "returns an error for blank name" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: "") }

        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "returns an error for blank email" do
        user_attributes = attributes_for(:user, email: "")
        post users_path, params: { user: user_attributes }

        expect(response.body).to include("Email can&#39;t be blank")
      end

      it "returns an error for password shorter than 6 characters" do
        user_attributes = attributes_for(:user, password: "")
        post users_path, params: { user: user_attributes }

        expect(response.body).to include("Password is too short")
      end

      it "returns an error for blank country code" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(country_code: "") }

        expect(response.body).to include("Country code can&#39;t be blank")
      end
    end
  end
end
