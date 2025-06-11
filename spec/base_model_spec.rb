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

    it 'where_ilike trouve les communes dont le nom contient une sous-chaîne (insensible à la casse)' do
      communes = DecoupageAdministratif::Commune.where_ilike(nom: 'mam')
      noms = communes.map(&:nom)
      expect(noms).to include('Mamers')
    end

    it 'where_ilike retourne un tableau vide si aucun nom ne correspond' do
      communes = DecoupageAdministratif::Commune.where_ilike(nom: 'ville-inexistante')
      expect(communes).to be_empty
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

    it 'retourne toutes les communes correspondant exactement au nom' do
      communes = DecoupageAdministratif::Commune.where(nom: 'Mamers')
      expect(communes.map(&:nom)).to eq(['Mamers'])
    end

    it 'retourne un tableau vide si aucune commune ne correspond' do
      communes = DecoupageAdministratif::Commune.where(nom: 'ville-inexistante')
      expect(communes).to be_empty
    end
  end
end
