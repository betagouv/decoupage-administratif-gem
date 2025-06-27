# frozen_string_literal: true

require "spec_helper"

RSpec.describe DecoupageAdministratif::Parser do
  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../fixtures') }

  before do
    allow(File).to receive(:dirname).and_return(fixtures_dir)
  end

  describe '#initialize' do
    context 'with valid JSON file' do
      let(:valid_json) { '[{"code":"72039","nom":"Bonnétable","typeLiaison":0,"zone":"metro","arrondissement":"722","departement":"72","region":"52","type":"commune-actuelle","rangChefLieu":0,"anciensCodes":["72014"],"siren":"217200393","codesPostaux":["72110"],"population":3735}]' }

      before do
        allow(File).to receive(:read).and_return(valid_json)
      end

      it 'successfully loads the data' do
        parser = described_class.new('communes')
        expect(parser.data).to be_an(Array)
        expect(parser.data.first).to include("code" => '72039')
      end
    end

    context 'when file does not exist' do
      before do
        allow(File).to receive(:read).and_raise(Errno::ENOENT)
      end

      it 'raises an error' do
        expect { described_class.new('invalid') }.to raise_error(
          DecoupageAdministratif::Error,
          "File #{File.expand_path("#{fixtures_dir}/data/invalid.json")} does not exist. You have to install the gem with 'rake decoupage_administratif:install'"
        )
      end
    end

    context 'with invalid JSON' do
      before do
        allow(File).to receive(:read).and_return('invalid json')
      end

      it 'raises an error' do
        expect { described_class.new('communes') }.to raise_error(
          DecoupageAdministratif::Error,
          "File communes.json is not valid JSON"
        )
      end
    end
  end
end
