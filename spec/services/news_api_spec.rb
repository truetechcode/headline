# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewsApi do
  describe "#call" do
    let(:data) { build_list(:populated_article, 2) }

    let(:instance) { described_class.new("us") }

    context "when API response returns success" do
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
      end

      let(:articles_empty) do
        allow(instance).to receive(:call).and_return(
          status: 200,
          body: {
            status: "ok",
            totalResults: 0,
            articles: []
          }.to_json,
          headers: { "Content-Type": "application/json" }
        )

        response = instance.call
        JSON.parse(response[:body])["articles"]
      end

      it "increment articles by 1" do
        expect(articles.length).to eq(2)
      end

      it "returns a successful response with articles" do
        expect(articles[1]["author"]).to eq("Susie Blann")
      end

      it "returns an empty array if the API response has no articles" do
        expect(articles_empty).to be_empty
      end
    end

    context "when API response returns error" do
      let(:articles_error) do
        allow(instance).to receive(:call).and_return(
          status: 500,
          body: "Internal Server Error"
        )

        response = instance.call
        response[:body]["articles"]
      end

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
            status: 500,
            body: {
              status: "error",
              message: "API error message"
            }.to_json,
            headers: { "Content-Type": "application/json" }
          )
      end

      it "returns nil" do
        expect(articles_error).to be_nil
      end

      it "logs the error message" do
        allow(Rails.logger).to receive(:error)
        instance.call
        expect(Rails.logger).to have_received(:error).with(/500: API error message/)
      end
    end
  end
end
