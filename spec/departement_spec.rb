# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Departement do
  let(:parsed_data) { JSON.parse(File.read('spec/fixtures/departements.json')) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with('departements').and_return(parser)
  end

  describe '#all' do
    subject { DecoupageAdministratif::Departement.all }

    it "Returns all departements" do
      expect(subject.size).to eq(3)
      expect(subject.first).to have_attributes(
        code: "76",
        nom: "Seine-Maritime",
        code_region: "28",
        zone: "metro"
      )
    end
  end

  describe "#find_by_code" do
    let(:code) { '78' }

    subject { DecoupageAdministratif::Departement.find_by_code(code) }

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
