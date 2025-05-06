# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Region do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    let(:model) { 'regions' }

    subject { DecoupageAdministratif::Region.all }

    it "Returns all regions" do
      expect(subject.size).to eq(26)
      expect(subject.first).to have_attributes(
        code: "01",
        nom: "Guadeloupe",
        zone: "drom"
      )
    end
  end

  describe 'find_by_code' do
    let(:model) { 'regions' }
    let(:code) { '53' }

    subject { DecoupageAdministratif::Region.find_by_code(code) }

    it 'Returns the region with the given code' do
      is_expected.to be_a(DecoupageAdministratif::Region)
      is_expected.to have_attributes(
        code: code,
        nom: "Bretagne",
        zone: "metro"
      )
    end
  end

  describe 'departements' do
    let(:model) { 'departements' }
    let!(:region) { DecoupageAdministratif::Region.new(code: '11', nom: 'Île-de-France', zone: 'metro') }

    subject { region.departements }

    it 'Returns the departements of the region' do
      expect(subject.size).to eq(2)
      is_expected.to all(be_a(DecoupageAdministratif::Departement))
      expect(subject.first).to have_attributes(
        code: '77',
        nom: 'Seine-et-Marne'
      )
    end
  end

  describe 'communes' do
    let(:model) { 'communes' }
    let!(:region) { DecoupageAdministratif::Region.new(code: '84', nom: 'Auvergne-Rhône-Alpes', zone: 'metro') }

    subject { region.communes }

    it 'Returns the actual communes of the region' do
      expect(subject.size).to eq(1)
      is_expected.to all(be_a(DecoupageAdministratif::Commune))
      expect(subject.first).to have_attributes(
        code: '01042',
        nom: 'Bey'
      )
    end
  end
end
