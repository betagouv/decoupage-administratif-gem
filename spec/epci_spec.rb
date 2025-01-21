# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::Epci do
  let(:parsed_data) { JSON.parse(File.read('spec/fixtures/epci.json')) }
  let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

  before do
    allow(DecoupageAdministratif::Parser).to receive(:new).with('epci').and_return(parser)
  end

  describe '#all' do
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
end
