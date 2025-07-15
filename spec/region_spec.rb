# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Region do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    subject { described_class.all }

    let(:model) { 'regions' }

    it "Returns all regions" do
      expect(subject.size).to eq(26)
      expect(subject.first).to have_attributes(
        code: "01",
        nom: "Guadeloupe",
        zone: "drom"
      )
    end
  end

  describe 'find_by' do
    context 'when searching by code' do
      subject { described_class.find_by(code: code) }

      let(:model) { 'regions' }
      let(:code) { '53' }

      it 'Returns the region with the given code' do
        expect(subject).to be_a(described_class)
        expect(subject).to have_attributes(
          code: code,
          nom: "Bretagne",
          zone: "metro"
        )
      end
    end
  end

  describe 'departements' do
    subject { region.departements }

    let(:model) { 'departements' }
    let!(:region) { described_class.new(code: '11', nom: 'Île-de-France', zone: 'metro') }

    it 'Returns the departements of the region' do
      expect(subject.size).to eq(2)
      expect(subject).to all(be_a(DecoupageAdministratif::Departement))
      expect(subject.first).to have_attributes(
        code: '77',
        nom: 'Seine-et-Marne'
      )
    end
  end

  describe 'communes' do
    subject { region.communes }

    let(:model) { 'communes' }
    let!(:region) { described_class.new(code: '84', nom: 'Auvergne-Rhône-Alpes', zone: 'metro') }

    it 'Returns the actual communes of the region' do
      expect(subject.size).to eq(1)
      expect(subject).to all(be_a(DecoupageAdministratif::Commune))
      expect(subject.first).to have_attributes(
        code: '01042',
        nom: 'Bey'
      )
    end
  end
end
