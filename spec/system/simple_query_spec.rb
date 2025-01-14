require "spec_helper"

RSpec.describe "Simple Tel Query", :vcr do
  let(:client) { TelSearch::Client.new(ENV["TEL_KEY"]) }

  subject { client.execute(query) }

  describe "where" do
    let(:where) { "Industriestrasse 44, 8304 Wallisellen" }
    let(:query) { TelSearch::Query.new(where: where) }

    it "returns a response with the informaton for the address" do
      entries = subject.entries
      expect(entries[0].name).to eq("Farnell AG")
      expect(entries[1].name).to eq("P&I Parfums GmbH")
      expect(entries[2].name).to eq("Eberhart Schmierstoffe AG Mobil Schmierstoffe")
      expect(entries[3].name).to eq("J'COCOS GmbH")
      expect(entries[4].name).to eq("Renuo AG")
    end
  end

  describe "what" do
    let(:query) { TelSearch::Query.new(what: what) }

    context "when the query is a tel number" do
      let(:what) { "071 2222 777" }

      it "returns a response with the company information" do
        expect(subject.entries.first.name).to eq("Herold Taxi AG")
      end
    end

    context "when the query is a name" do
      let(:what) { "Renuo AG" }

      it "returns a response with the company information" do
        expect(subject.entries.first.name).to eq("Renuo AG")
      end
    end
  end
end
