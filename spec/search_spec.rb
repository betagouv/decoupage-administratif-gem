# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Search do
  let(:parsed_data_departements) { JSON.parse(File.read("spec/fixtures/departements.json")) }
  let(:parsed_data_communes) { JSON.parse(File.read("spec/fixtures/communes.json")) }
  let(:parsed_data_epci) { JSON.parse(File.read("spec/fixtures/epci.json")) }
  let(:parsed_data_regions) { JSON.parse(File.read("spec/fixtures/regions.json")) }
  let(:parser_departements) { instance_double(DecoupageAdministratif::Parser, data: parsed_data_departements) }
  let(:parser_communes) { instance_double(DecoupageAdministratif::Parser, data: parsed_data_communes) }
  let(:parser_epci) { instance_double(DecoupageAdministratif::Parser, data: parsed_data_epci) }
  let(:parser_regions) { instance_double(DecoupageAdministratif::Parser, data: parsed_data_regions) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with('departements').and_return(parser_departements)
    allow(DecoupageAdministratif::Parser).to receive(:new).with('communes').and_return(parser_communes)
    allow(DecoupageAdministratif::Parser).to receive(:new).with('epci').and_return(parser_epci)
    allow(DecoupageAdministratif::Parser).to receive(:new).with('regions').and_return(parser_regions)
  end

  describe '#by_insee_codes' do
    context "when finding departement" do
      subject { described_class.new(%w[01042 01015]).by_insee_codes }

      it "Returns a departement" do
        expect(subject[:departements].size).to eq(1)
        expect(subject[:departements].first).to have_attributes(
          code: "01",
          nom: "Ain",
          zone: "metro",
          code_region: "84"
        )
      end
    end

    context "when finding epci" do
      subject { described_class.new(%w[72180 72039 72189 72276 72026 72215 72220 72196 72316 72101 72104 72048]).by_insee_codes }

      it "Returns an epci" do
        expect(subject[:epcis].size).to eq(1)
        expect(subject[:epcis].first).to have_attributes(
          code: "200072676",
          nom: "CC Maine Saosnois"
        )
      end
    end

    context "when finding communes" do
      subject { described_class.new(%w[72180 72039]).by_insee_codes }

      it "Returns communes" do
        expect(subject[:communes].size).to eq(2)
        expect(subject[:communes].first).to have_attributes(
          code: "72180",
          nom: "Mamers",
          zone: "metro",
          region_code: "52",
          departement_code: "72"
        )
        expect(subject[:communes].last).to have_attributes(
          code: "72039",
          nom: "Bonnétable",
          zone: "metro",
          region_code: "52",
          departement_code: "72"
        )
      end
    end

    context "with no matching codes" do
      subject { described_class.new(%w[99999 88888]).by_insee_codes }

      it "returns only empty arrays" do
        expect(subject[:regions]).to eq([])
        expect(subject[:departements]).to eq([])
        expect(subject[:epcis]).to eq([])
        expect(subject[:communes]).to eq([])
      end
    end

    context "with partially matching codes" do
      subject { described_class.new(%w[72180 99999]).by_insee_codes }

      it "returns only the valid commune" do
        expect(subject[:communes].map(&:code)).to include("72180")
        expect(subject[:communes].map(&:code)).not_to include("99999")
      end
    end
  end

  describe '#find_territories_by_commune_insee_code' do
    context "when the code INSEE corresponds to a valid commune" do
      let(:commune) { instance_double(DecoupageAdministratif::Commune, code: "94068", epci: "Métropole du Grand Paris", departement: "Val-de-Marne", region: "Île-de-France") }

      before do
        allow(DecoupageAdministratif::Commune).to receive(:find_by).with(code: "94068").and_return(commune)
      end

      it "returns the associated territories" do
        result = described_class.new([]).find_territories_by_commune_insee_code("94068")
        expect(result[:epci]).to eq("Métropole du Grand Paris")
        expect(result[:departement]).to eq("Val-de-Marne")
        expect(result[:region]).to eq("Île-de-France")
      end
    end

    context "when the code INSEE does not correspond to any commune" do
      before do
        allow(DecoupageAdministratif::Commune).to receive(:find_by).with(code: "99999").and_return(nil)
      end

      it "returns an empty hash" do
        result = described_class.new([]).find_territories_by_commune_insee_code("99999")
        expect(result).to eq({})
      end
    end
  end
end
