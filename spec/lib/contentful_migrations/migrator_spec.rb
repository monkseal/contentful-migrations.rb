RSpec.describe ContentfulMigrations::Migrator do
  describe '.migrate' do
    let(:migrated) { double(:migrated) }

    before do
      expect(described_class).to receive(:new).and_return(double(:m, migrate: migrated))
    end

    it 'calls migrate' do
      expect(described_class.migrate).to eq(migrated)
    end
  end

  describe '.rollback' do
    let(:rolledback) { double(:rolledback) }

    before do
      expect(described_class).to receive(:new).and_return(double(:m, rollback: rolledback))
    end

    it 'calls migrate' do
      expect(described_class.rollback).to eq(rolledback)
    end
  end

  describe '.pending' do
    let(:pending_result) { double(:pending_result) }

    before do
      expect(described_class).to receive(:new).and_return(double(:m, pending: pending_result))
    end

    it 'calls migrate' do
      expect(described_class.pending).to eq(pending_result)
    end
  end
end
