RSpec.describe ContentfulMigrations::MigrationContentType do
  let(:client) { double(:client) }
  let(:space) { double(:space) }

  let(:logger) { double(:logger) }
  let(:defaults) do
    {
      client: client,
      space: space,
      logger: logger
    }
  end

  describe '#initialize' do
    it 'sets name and version' do
      migrator = described_class.new(defaults)

      expect(migrator.client).to eq(client)
      expect(migrator.space).to eq(space)
      expect(migrator.migration_content_type_name).to eq('migrations')
    end
  end

  describe '#resolve' do
    subject { described_class.new(defaults) }

    let(:content_types) { double(:content_types) }
    let(:migration_content_type) { double(:migration_content_type) }
    context 'when content type exists' do
      before do
        expect(space).to receive(:content_types).and_return(content_types)
        expect(content_types).to receive(:find).with('migrations').and_return(migration_content_type)
      end

      it 'calls contentful to retrive content type' do
        expect(subject.resolve).to eq(migration_content_type)
      end
    end

    context 'when content type not exist' do
      let(:fields) { double(:fields) }
      before do
        allow(space).to receive(:content_types).and_return(content_types)
        expect(content_types).to receive(:find).with('migrations').and_return(nil)
        expect(content_types).to receive(:create).with(
          name: 'migrations',
          id: 'migrations',
          description: 'Migration Table for interal use only, do not delete'
        ).and_return(migration_content_type)
        expect(migration_content_type).to receive(:fields).and_return(fields)
        expect(fields).to receive(:create).with(
          id: 'version', name: 'version', type: 'Integer'
        )
        expect(migration_content_type).to receive(:save)
        expect(migration_content_type).to receive(:publish)
      end

      it 'calls contentful to retrive content type' do
        expect(subject.resolve).to eq(migration_content_type)
      end
    end
  end
end
