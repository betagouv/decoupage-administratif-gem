# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Search do
  let(:parsed_data1) { JSON.parse(File.read("spec/fixtures/departements.json")) }
  let(:parsed_data2) { JSON.parse(File.read("spec/fixtures/communes.json")) }
  let(:parsed_data3) { JSON.parse(File.read("spec/fixtures/epci.json")) }
  let(:parser1) { instance_double(DecoupageAdministratif::Parser, data: parsed_data1) }
  let(:parser2) { instance_double(DecoupageAdministratif::Parser, data: parsed_data2) }
  let(:parser3) { instance_double(DecoupageAdministratif::Parser, data: parsed_data3) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with('departements').and_return(parser1)
    allow(DecoupageAdministratif::Parser).to receive(:new).with('communes').and_return(parser2)
    allow(DecoupageAdministratif::Parser).to receive(:new).with('epci').and_return(parser3)
  end

  describe '#by_insee_codes' do
    context "find departement" do
      subject { DecoupageAdministratif::Search.new(["01042", "01015"]).by_insee_codes }

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

    context "find epci" do
      subject { DecoupageAdministratif::Search.new(%w[72180 72039 72189 72276 72026 72215 72220 72196 72316 72101 72104 72048]).by_insee_codes }

      it "Returns an epci" do
        expect(subject[:epcis].size).to eq(1)
        expect(subject[:epcis].first).to have_attributes(
          code: "200072676",
          nom: "CC Maine Saosnois",
        )
      end
    end

    context "find communes" do
      subject { DecoupageAdministratif::Search.new(%w[72180 72039]).by_insee_codes }

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
  end
end