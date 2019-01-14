RSpec.describe ContentfulMigrations::Migrator do
  ########
  ## Class methods
  ########

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

  ########
  ## Instance methods
  ########

  let(:logger) { double(:logger) }
  let(:defaults) do
    { migrations_path: 'spec/db/contentful_migrations',
      access_token: 'access_token',
      space_id: 'space_id',
      migration_content_type_name: ContentfulMigrations::MigrationContentType::DEFAULT_MIGRATION_CONTENT_TYPE,
      logger: logger,
      env_id: 'master' }
  end

  describe '#initialize' do
    it 'sets name and version' do
      migrator = described_class.new(defaults)

      expect(migrator.migrations_path).to eq('spec/db/contentful_migrations')
      expect(migrator.access_token).to eq('access_token')
      expect(migrator.space_id).to eq('space_id')
      expect(migrator.migration_content_type_name).to eq('migrations')
      expect(migrator.env_id).to eq('master')
    end
    it 'raises error when invalid path' do
      expect do
        described_class.new(defaults.merge(migrations_path: 'bad/path'))
      end.to raise_error(ContentfulMigrations::Migrator::InvalidMigrationPath)
    end
  end
  describe '#migrate' do
    subject { described_class.new(defaults) }
    context 'when no migrations' do
      before do
        allow(subject).to receive(:migrations).and_return([])
        expect(logger).to receive(:info)
      end

      it 'sets name and version' do
        expect(subject.migrate).to eq(subject)
      end
    end

    context 'when migrations' do
      let(:client) { double(:client) }
      let(:spaces) { double(:spaces) }
      let(:space) { double(:space) }
      let(:content_types) { double(:content_types) }
      let(:migration_content_type) { double(:migration_content_type) }
      let(:entries) { double(:entries, all: all) }
      let(:all) { [] }
      let(:migration) { double(:migration, version: 20_180_216_021_826, name: 'BuildTestContent') }

      before do
        expect(Contentful::Management::Client).to receive(:new).and_return(client)
        expect(client).to receive(:environments).with('space_id').and_return(space)
        expect(space).to receive(:find).with('master').and_return(space)
        allow(subject).to receive(:migration_content_type).and_return(migration_content_type)
      end

      before do
        expect(migration_content_type).to receive(:entries).and_return(entries)
        expect(ContentfulMigrations::MigrationProxy).to receive(:new).with(
          'BuildTestContent',
          20_180_216_021_826,
          'spec/db/contentful_migrations/20180216021826_build_test_content.rb',
          ''
        ).and_return(migration)
        expect(migration).to receive(:migrate).with(:up, client, space)
        expect(migration).to receive(:record_migration).with(migration_content_type)
        allow(logger).to receive(:info)
      end

      it 'sets name and version' do
        expect(subject.migrate).to eq(subject)
      end
    end
  end
end
