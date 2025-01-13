# froen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Commune do
  describe '#all' do
    let(:parsed_data) { JSON.parse(File.read('spec/fixtures/communes.json')) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    subject { DecoupageAdministratif::Commune.all }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with('communes').and_return(parser)
    end

    it "Returns all communes" do
      expect(subject.size).to eq(3)
      expect(subject.first).to have_attributes(
        code: "72038",
        nom: "Boëssé-le-Sec",
        zone: "metro",
        region: "52",
        departement: "72"
      )
    end
  end
end
