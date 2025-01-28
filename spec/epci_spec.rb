# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Epci do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    let(:model) { 'epci' }
    subject { DecoupageAdministratif::Epci.all }

    it "Returns all epcis" do
      expect(subject.size).to eq(2)
      expect(subject.first).to have_attributes(
        code: "200072676",
        nom: "CC Maine Saosnois"
      )
    end
  end

  describe 'find_by_code' do
    let(:model) { 'epci' }
    let(:code) { '200072684' }

    subject { DecoupageAdministratif::Epci.find_by_code(code) }

    it 'Returns the epci with the given code' do
      is_expected.to be_a(DecoupageAdministratif::Epci)
      is_expected.to have_attributes(
        code: code,
        nom: "CC Le Gesnois Bilurien"
      )
    end
  end

  describe '#communes' do
    let(:model) { 'communes' }
    let(:epci) do
      DecoupageAdministratif::Epci.new(code: "200072676",
                                       membres:
                                                   [{ "code" => "72180", "nom" => "Mamers" },
                                                    { "code" => "72039", "nom" => "Bonnétable" },
                                                    { "code" => "72189", "nom" => "Marolles-les-Braults" },
                                                    { "code" => "72276", "nom" => "Saint-Cosme-en-Vairais" },
                                                    { "code" => "72026", "nom" => "Beaufay" },
                                                    { "code" => "72215", "nom" => "Neufchâtel-en-Saosnois" },
                                                    { "code" => "72220", "nom" => "Nogent-le-Bernard" },
                                                    { "code" => "72196", "nom" => "Mézières-sur-Ponthouin" },
                                                    { "code" => "72316", "nom" => "Saint-Rémy-des-Monts" },
                                                    { "code" => "72101", "nom" => "Courcemont" },
                                                    { "code" => "72104", "nom" => "Courgains" },
                                                    { "code" => "72048", "nom" => "Briosne-lès-Sables" }],
                                       nom: "CC Maine Saosnois")
    end
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/epci_communes.json")) }
    subject { epci.communes }

    it 'Returns the communes of the epci' do
      is_expected.to all(be_a(DecoupageAdministratif::Commune))

      expect(subject.first).to have_attributes(
        code: '72180',
        nom: 'Mamers'
      )
      expect(subject.size).to eq(12)
    end
  end
end
