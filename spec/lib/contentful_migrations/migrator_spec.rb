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

  describe '#initialize' do
    let(:options) do
      { migrations_path: 'spec/db/contentful_migrations',
        access_token: 'access_token',
        space_id: 'space_id',
        migration_content_type_name: 'x_migrations',
        logger: double(:logger) }
    end
    it 'sets name and version' do
      migrator = described_class.new(options)

      expect(migrator.migrations_path).to eq('spec/db/contentful_migrations')
      expect(migrator.access_token).to eq('access_token')
      expect(migrator.space_id).to eq('space_id')
      expect(migrator.migration_content_type_name).to eq('x_migrations')
    end
    it 'raises error when invalid path' do
      expect {
        described_class.new(options.merge(migrations_path: "bad/path"))
      }.to raise_error(ContentfulMigrations::Migrator::InvalidMigrationPath)
    end
  end
end
