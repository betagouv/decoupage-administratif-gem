# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Departement do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    subject { described_class.all }

    let(:model) { 'departements' }

    it "Returns all departements" do
      expect(subject.size).to eq(6)
      expect(subject.first).to have_attributes(
        code: "01",
        nom: "Ain",
        code_region: "84",
        zone: "metro"
      )
    end
  end

  describe "#find_by" do
    context 'when searching by code' do
      subject { described_class.find_by(code: code) }

      let(:model) { 'departements' }
      let(:code) { '78' }

      it 'Returns the departement with the given code' do
        expect(subject).to be_a(described_class)
        expect(subject).to have_attributes(
          code: code,
          nom: "Yvelines",
          zone: "metro",
          code_region: "11"
        )
      end
    end
  end

  describe '#communes' do
    subject { departement.communes }

    let(:model) { 'communes' }
    let(:departement) { described_class.new(code: '72', nom: 'Sarthe', zone: 'metro', code_region: '52') }

    it 'Returns the actual communes of the departement' do
      expect(subject).to all(be_a(DecoupageAdministratif::Commune))
      expect(subject.first).to have_attributes(
        code: '72180',
        nom: 'Mamers'
      )
      expect(subject.size).to eq(13)
    end
  end

  describe '#region' do
    subject { departement.region }

    let(:model) { 'regions' }
    let(:departement) { described_class.new(code: '72', nom: 'Sarthe', zone: 'metro', code_region: '52') }

    it 'Returns the region of the departement' do
      expect(subject).to be_a(DecoupageAdministratif::Region)
      expect(subject).to have_attributes(
        code: '52',
        nom: 'Pays de la Loire'
      )
    end
  end
end
