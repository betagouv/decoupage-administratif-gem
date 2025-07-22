# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe DecoupageAdministratif::BaseModel do
  describe '.where with options' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'finds communes whose name contains a substring (case insensitive)' do
      communes = DecoupageAdministratif::Commune.where(nom: 'mam', case_insensitive: true, partial: true)
      noms = communes.map(&:nom)
      expect(noms).to include('Mamers')
    end

    it 'returns an empty array if no name matches' do
      communes = DecoupageAdministratif::Commune.where(nom: 'ville-inexistante', case_insensitive: true, partial: true)
      expect(communes).to be_empty
    end
  end

  describe '.find' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'returns the commune matching the given code' do
      commune = DecoupageAdministratif::Commune.find('72180')
      expect(commune).not_to be_nil
      expect(commune.code).to eq('72180')
      expect(commune.nom).to eq('Mamers')
    end

    it 'raises an exception if no commune matches the code' do
      expect do
        DecoupageAdministratif::Commune.find('99999')
      end.to raise_error(DecoupageAdministratif::NotFoundError, 'Commune not found for code 99999')
    end
  end

  describe '.find_by' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'returns the first commune matching exactly the name' do
      commune = DecoupageAdministratif::Commune.find_by(nom: 'Mamers')
      expect(commune).not_to be_nil
      expect(commune.nom).to eq('Mamers')
    end

    it 'returns nil if no commune matches' do
      commune = DecoupageAdministratif::Commune.find_by(nom: 'ville-inexistante')
      expect(commune).to be_nil
    end
  end

  describe '.where' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'returns all communes matching exactly the name and code' do
      communes = DecoupageAdministratif::Commune.where(nom: 'Mamers', code: "72180")
      expect(communes.map(&:nom)).to eq(['Mamers'])
    end

    it 'returns an empty array if no commune matches' do
      communes = DecoupageAdministratif::Commune.where(nom: 'ville-inexistante')
      expect(communes).to be_empty
    end
  end
end
