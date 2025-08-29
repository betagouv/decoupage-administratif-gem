# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecoupageAdministratif::TerritoryExtensions do
  describe '#includes_any_commune_code?' do
    subject { territory.includes_any_commune_code?(commune_insee_codes) }

    context 'with empty array' do
      let(:territory) { DecoupageAdministratif::Commune.all.first }
      let(:commune_insee_codes) { [] }

      it { is_expected.to be false }
    end

    context 'with Commune' do
      let(:territory) { DecoupageAdministratif::Commune.find('72180') } # Mamers

      context 'when commune code is in the array' do
        let(:commune_insee_codes) { %w[72180 75001 69001] }

        it { is_expected.to be true }
      end

      context 'when commune code is not in the array' do
        let(:commune_insee_codes) { %w[75001 69001 13001] }

        it { is_expected.to be false }
      end
    end

    context 'with Departement' do
      let(:territory) { DecoupageAdministratif::Departement.find('72') } # Sarthe

      context 'when any commune from the department is in the array' do
        let(:commune_insee_codes) { %w[72180 75001] } # Mamers is in Sarthe (72)

        it { is_expected.to be true }
      end

      context 'when no commune from the department is in the array' do
        let(:commune_insee_codes) { %w[75001 69001 13001] } # No commune from 72

        it { is_expected.to be false }
      end

      context 'with department code prefixes' do
        let(:commune_insee_codes) { ['72999'] } # Any 72xxx code should match

        it { is_expected.to be true }
      end
    end

    context 'with Region' do
      let(:territory) { DecoupageAdministratif::Region.find('52') } # Pays de la Loire

      context 'when any commune from the region is in the array' do
        let(:commune_insee_codes) { %w[72180 75001] } # Mamers is in Pays de la Loire

        it { is_expected.to be true }
      end

      context 'when no commune from the region is in the array' do
        let(:commune_insee_codes) { %w[75001 69001 13001] } # No commune from region 52

        it { is_expected.to be false }
      end

      context 'with overseas territories codes' do
        let(:commune_insee_codes) { ['97101'] } # Guadeloupe

        it { is_expected.to be false }
      end
    end

    context 'with Epci' do
      let(:territory) { DecoupageAdministratif::Epci.all.first }

      context 'when any member commune is in the array' do
        let(:member_code) { territory.membres.first["code"] }
        let(:commune_insee_codes) { [member_code, '75001'] }

        it { is_expected.to be true }
      end

      context 'when no member commune is in the array' do
        let(:commune_insee_codes) { %w[75001 69001 13001] }

        it { is_expected.to be false }
      end
    end
  end

  describe '#territory_insee_codes' do
    subject { territory.territory_insee_codes }

    context 'with Commune' do
      let(:territory) { DecoupageAdministratif::Commune.find('72180') }

      it { is_expected.to eq(['72180']) }

      it 'memoizes the result' do
        first_call = subject
        second_call = territory.territory_insee_codes
        expect(first_call).to be(second_call) # Same object reference
      end
    end

    context 'with Departement' do
      let(:territory) { DecoupageAdministratif::Departement.find('72') }

      it { is_expected.to be_an(Array) }
      it { is_expected.to include('72180') } # Mamers should be included

      it 'returns codes starting with department prefix' do
        expect(subject.all? { |code| code.start_with?('72') }).to be true
      end

      it 'memoizes the result' do
        first_call = subject
        second_call = territory.territory_insee_codes
        expect(first_call).to be(second_call)
      end
    end

    context 'with Region' do
      let(:territory) { DecoupageAdministratif::Region.find('52') }

      it { is_expected.to be_an(Array) }
      it { is_expected.to include('72180') } # Mamers should be included
      it { is_expected.not_to be_empty }

      it 'memoizes the result' do
        first_call = subject
        second_call = territory.territory_insee_codes
        expect(first_call).to be(second_call)
      end
    end

    context 'with Epci' do
      let(:territory) { DecoupageAdministratif::Epci.all.first }
      let(:expected_codes) { territory.membres.map { |m| m["code"] } }

      it { is_expected.to eq(expected_codes) }

      it 'memoizes the result' do
        first_call = subject
        second_call = territory.territory_insee_codes
        expect(first_call).to be(second_call)
      end
    end
  end
end
