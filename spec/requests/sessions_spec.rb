# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sessions" do
    let(:user) do
      { name: "user", email: "user@example.com", password: "password", password_confirmation: "password",
        country_code: "us" }
    end
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

    before do
      allow_any_instance_of(NewsApi).to receive(:call).and_return(articles)
    end

    context "with valid credentials" do
      before do
        User.create! user
        post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a success notice" do
        expect(flash[:success]).to eq("Logged in successfully.")
      end

      it "renders 'Logged in successfully.'" do
        follow_redirect!

        expect(response.body).to include("Logged in successfully.")
      end
    end

    context "with invalid credentials" do
      before do
        User.create! user
        post sessions_path, params: { session: { email: "user@example.com", password: "" } }
      end

      it "sets an alert flash message" do
        expect(response.body).to include("Invalid email or password.")
      end
    end
  end

  describe "DELETE /sessions" do
    let(:user) do
      create(:user, name: "user", email: "user@example.com", password: "password", password_confirmation: "password",
                    country_code: "us")
    end

    before do
      post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
      delete session_path(user)
    end

    it "redirects to root path" do
      expect(response).to redirect_to(root_path)
    end

    it "sets the flash notice message" do
      expect(flash[:success]).to eq("Logged out successfully.")
    end
  end
end
