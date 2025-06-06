# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Departement do
  let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
  end

  describe '#all' do
    let(:model) { 'departements' }
    subject { DecoupageAdministratif::Departement.all }

    it "Returns all departements" do
      expect(subject.size).to eq(5)
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
      let(:model) { 'departements' }
      let(:code) { '78' }

      subject { DecoupageAdministratif::Departement.find_by(code: code) }

      it 'Returns the departement with the given code' do
        is_expected.to be_a(DecoupageAdministratif::Departement)
        is_expected.to have_attributes(
          code: code,
          nom: "Yvelines",
          zone: "metro",
          code_region: "11"
        )
      end
    end
  end

  describe '#communes' do
    let(:model) { 'communes' }
    let(:departement) { DecoupageAdministratif::Departement.new(code: '72', nom: 'Sarthe', zone: 'metro', code_region: '52') }

    subject { departement.communes }

    it 'Returns the actual communes of the departement' do
      is_expected.to all(be_a(DecoupageAdministratif::Commune))
      expect(subject.first).to have_attributes(
        code: '72180',
        nom: 'Mamers'
      )
      expect(subject.size).to eq(13)
    end
  end

  describe '#region' do
    let(:model) { 'regions' }
    let(:departement) { DecoupageAdministratif::Departement.new(code: '72', nom: 'Sarthe', zone: 'metro', code_region: '52') }

    subject { departement.region }

    it 'Returns the region of the departement' do
      is_expected.to be_a(DecoupageAdministratif::Region)
      is_expected.to have_attributes(
        code: '52',
        nom: 'Pays de la Loire'
      )
    end
  end
end
