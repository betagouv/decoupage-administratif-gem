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
      expect(subject.size).to eq(4)
      expect(subject.first).to have_attributes(
        code: "72038",
        nom: "Boëssé-le-Sec",
        zone: "metro",
        region: "52",
        departement_code: "72"
      )
    end
  end

  describe 'find_by_code' do
    let(:model) { 'communes' }
    let(:code) { '72039' }

    subject { DecoupageAdministratif::Commune.find_by_code(code) }

    it 'Returns the commune with the given code' do
      is_expected.to be_a(DecoupageAdministratif::Commune)
      is_expected.to have_attributes(
        code: code,
        nom: "Bonnétable",
        zone: "metro",
        region: "52",
        departement_code: "72"
      )
    end
  end

  describe '#departement' do
    let(:model) { 'departements' }
    let(:commune) { DecoupageAdministratif::Commune.new(code: '78380', nom: 'Maule', zone: 'metro', region: '11', departement_code: '78') }

    subject { commune.departement }

    it 'Returns the departement of the commune' do
      is_expected.to be_a(DecoupageAdministratif::Departement)
      is_expected.to have_attributes(
        code: '78',
        nom: 'Yvelines'
      )
    end
  end
end
