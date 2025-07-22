# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Commune do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    let(:model) { 'communes' }
    subject { DecoupageAdministratif::Commune.all }

    it "Returns all communes" do
      expect(subject.size).to eq(16)
      expect(subject.first).to have_attributes(
        code: "72180",
        nom: "Mamers",
        zone: "metro",
        region_code: "52",
        departement_code: "72"
      )
    end
  end

  describe '#communes_actuelles' do
    let(:model) { 'communes' }
    subject { DecoupageAdministratif::Commune.actuelles }

    it "Returns all communes actuelles" do
      expect(subject.size).to eq(14)
      expect(subject.last).to have_attributes(
        code: "01042",
        nom: "Bey",
        zone: "metro",
        region_code: "84",
        departement_code: "01"
      )
    end
  end

  describe 'find_by' do
    context 'when searching by code' do
      let(:model) { 'communes' }
      let(:code) { '72039' }

      subject { DecoupageAdministratif::Commune.find_by(code: code) }

      it 'Returns the commune with the given code' do
        is_expected.to be_a(DecoupageAdministratif::Commune)
        is_expected.to have_attributes(
          code: code,
          nom: "Bonnétable",
          zone: "metro",
          region_code: "52",
          departement_code: "72"
        )
      end
    end
  end

  describe '#departement' do
    let(:model) { 'departements' }
    let(:commune) { DecoupageAdministratif::Commune.new(code: '78380', nom: 'Maule', zone: 'metro', region_code: '11', departement_code: '78') }

    subject { commune.departement }

    it 'Returns the departement of the commune' do
      is_expected.to be_a(DecoupageAdministratif::Departement)
      is_expected.to have_attributes(
        code: '78',
        nom: 'Yvelines'
      )
    end
  end

  describe '#epci' do
    let(:model) { 'epci' }
    let(:commune) { DecoupageAdministratif::Commune.new(code: '72039', nom: 'Bonnétable', zone: 'metro', region_code: '52', departement_code: '72') }

    subject { commune.epci }

    it 'Returns the epci of the commune' do
      is_expected.to be_a(DecoupageAdministratif::Epci)
      is_expected.to have_attributes(
        code: '200072676',
        nom: 'CC Maine Saosnois'
      )
    end
  end

  describe '#region' do
    let(:model) { 'regions' }
    let(:commune) { DecoupageAdministratif::Commune.new(code: '72039', nom: 'Bonnétable', zone: 'metro', region_code: '52', departement_code: '72') }

    subject { commune.region }

    it "Returns the region of the commune" do
      is_expected.to be_a(DecoupageAdministratif::Region)
      is_expected.to have_attributes(
        code: "52",
        nom: "Pays de la Loire"
      )
    end
  end
end
