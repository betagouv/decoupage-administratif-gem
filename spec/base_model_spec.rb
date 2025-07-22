# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe DecoupageAdministratif::BaseModel do
  describe '.where avec options' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'trouve les communes dont le nom contient une sous-chaîne (insensible à la casse)' do
      communes = DecoupageAdministratif::Commune.where(nom: 'mam', case_insensitive: true, partial: true)
      noms = communes.map(&:nom)
      expect(noms).to include('Mamers')
    end

    it 'retourne un tableau vide si aucun nom ne correspond' do
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

    it 'retourne la commune correspondant au code donné' do
      commune = DecoupageAdministratif::Commune.find('72180')
      expect(commune).not_to be_nil
      expect(commune.code).to eq('72180')
      expect(commune.nom).to eq('Mamers')
    end

    it 'lève une exception si aucune commune ne correspond au code' do
      expect {
        DecoupageAdministratif::Commune.find('99999')
      }.to raise_error(DecoupageAdministratif::NotFoundError, 'Commune not found for code 99999')
    end
  end

  describe '.find_by' do
    let(:model) { 'communes' }
    let(:parsed_data) { JSON.parse(File.read("spec/fixtures/#{model}.json")) }
    let(:parser) { instance_double(DecoupageAdministratif::Parser, data: parsed_data) }

    before do
      allow(DecoupageAdministratif::Parser).to receive(:new).with(model).and_return(parser)
    end

    it 'retourne la première commune correspondant exactement au nom' do
      commune = DecoupageAdministratif::Commune.find_by(nom: 'Mamers')
      expect(commune).not_to be_nil
      expect(commune.nom).to eq('Mamers')
    end

    it 'retourne nil si aucune commune ne correspond' do
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

    it 'retourne toutes les communes correspondant exactement au nom et code' do
      communes = DecoupageAdministratif::Commune.where(nom: 'Mamers', code: "72180")
      expect(communes.map(&:nom)).to eq(['Mamers'])
    end

    it 'retourne un tableau vide si aucune commune ne correspond' do
      communes = DecoupageAdministratif::Commune.where(nom: 'ville-inexistante')
      expect(communes).to be_empty
    end
  end
end
