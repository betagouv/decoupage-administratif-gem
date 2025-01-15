# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Region do
  let(:parsed_data) { JSON.parse(File.read('spec/fixtures/regions.json')) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with('regions').and_return(parser)
  end

  describe '#all' do
    subject { DecoupageAdministratif::Region.all }

    it "Returns all regions" do
      expect(subject.size).to eq(3)
      expect(subject.first).to have_attributes(
        code: "52",
        nom: "Pays de la Loire",
        zone: "metro"
      )
    end
  end

  describe 'find_by_code' do
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
end
