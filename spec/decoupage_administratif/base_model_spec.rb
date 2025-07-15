# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe DecoupageAdministratif::BaseModel do
  describe '.where_ilike' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    context "when searching for communes with name containing substring" do
      it 'finds communes whose name contains a substring (case insensitive)' do
        communes = DecoupageAdministratif::Commune.where_ilike(nom: 'mam')
        noms = communes.map(&:nom)
        expect(noms).to include('Mamers')
      end
    end

    context "when no commune matches the search criteria" do
      it 'returns an empty array if no name matches' do
        communes = DecoupageAdministratif::Commune.where_ilike(nom: 'ville-inexistante')
        expect(communes).to be_empty
      end
    end
  end

  describe '.find_by' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    context "when finding a commune by exact name match" do
      it 'returns the first commune matching exactly the name' do
        commune = DecoupageAdministratif::Commune.find_by(nom: 'Mamers')
        expect(commune).not_to be_nil
        expect(commune.nom).to eq('Mamers')
      end
    end

    context "when no commune matches the search criteria" do
      it 'returns nil if no commune matches' do
        commune = DecoupageAdministratif::Commune.find_by(nom: 'ville-inexistante')
        expect(commune).to be_nil
      end
    end
  end

  describe '.where' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    context "when searching with exact match criteria" do
      it 'returns communes matching the exact criteria' do
        communes = DecoupageAdministratif::Commune.where(departement_code: '72')
        expect(communes).not_to be_empty
        expect(communes.all? { |c| c.departement_code == '72' }).to be true
      end
    end

    context "when no commune matches the criteria" do
      it 'returns an empty array when no matches are found' do
        communes = DecoupageAdministratif::Commune.where(departement_code: '99')
        expect(communes).to be_empty
      end
    end
  end
end
