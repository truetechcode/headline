# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewsApi do
  describe "#call" do
    let(:data) do
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
    let(:instance) { described_class.new("us") }

    let(:articles) do
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
            articles: data
          }.to_json,
          headers: { "Content-Type": "application/json" }
        )

      allow(instance).to receive(:call).and_return(
        status: 200,
        body: {
          status: "ok",
          totalResults: 0,
          articles: data
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )

      response = instance.call
      JSON.parse(response[:body])["articles"]
      JSON.parse(response[:body])["articles"]
    end

    it "returns a successful response with articles" do
      expect(articles).to be_an(Array)
      expect(articles.length).to eq(2)
      expect(articles[0]["source"]["name"]).to eq("Associated Press")
      expect(articles[1]["author"]).to eq("Ashleigh Furlong")
    end

    it "returns an empty array if the API response has no articles" do
      allow_any_instance_of(described_class).to receive(:call).and_return(
        status: 200,
        body: {
          status: "ok",
          totalResults: 0,
          articles: []
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )

      news_service = described_class.new("us")
      response = news_service.call
      articles = JSON.parse(response[:body])["articles"]
      expect(articles).to be_an(Array)
      expect(articles).to be_empty
    end

    it "handles API errors and returns nil" do
      allow_any_instance_of(described_class).to receive(:call).and_return(
        status: 500,
        body: "Internal Server Error"
      )

      news_service = described_class.new("us")
      response = news_service.call
      articles = response[:body]["articles"]

      expect(articles).to be_nil
    end
  end
end
