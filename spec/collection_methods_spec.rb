# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::CollectionMethods do
  let(:collection) { DecoupageAdministratif::CommuneCollection.new([commune, commune, commune]) }
  let(:commune) { DecoupageAdministratif::Commune.new(code: "72038", nom: "Boëssé-le-Sec", zone: "metro", departement_code: "72", region_code: "53") }

  describe "#first" do
    it "returns a single commune when called without argument" do
      expect(collection.first).to be_a(DecoupageAdministratif::Commune)
    end

    it "returns a collection when called with argument" do
      expect(collection.first(2)).to be_a(DecoupageAdministratif::CommuneCollection)
      expect(collection.first(2).size).to eq(2)
    end
  end

  describe "#last" do
    it "returns a single commune when called without argument" do
      expect(collection.last).to be_a(DecoupageAdministratif::Commune)
    end

    it "returns a collection when called with argument" do
      expect(collection.last(2)).to be_a(DecoupageAdministratif::CommuneCollection)
      expect(collection.last(2).size).to eq(2)
    end
  end
end
