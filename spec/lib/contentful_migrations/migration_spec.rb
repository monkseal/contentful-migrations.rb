RSpec.describe ContentfulMigrations::Migration do
  let(:version) { '20180216021826' }
  let(:name) { 'BuildTestContent' }
  let(:client) { double(:contentful_client) }
  let(:space) { double(:contentful_space) }

  subject { described_class.new(name, version) }
  describe '#initialize' do
    it 'sets name and version' do
      expect(subject.name).to eq('BuildTestContent')
      expect(subject.version).to eq('20180216021826')
    end
  end

  describe '#migrate' do
    context 'when direction is up' do
      before do
        expect(subject).to receive(:up)
      end

      it 'calls up and returns self' do
        expect(subject.migrate(:up, :client, :space)).to eq(subject)
      end
    end

    context 'when direction is down' do
      before do
        expect(subject).to receive(:down)
      end

      it 'calls up and returns self' do
        expect(subject.migrate(:down, :client, :space)).to eq(subject)
      end
    end
  end

  describe '#with_space' do
    subject { described_class.new(name, version, client, space) }

    let(:stub) { double(:stub, callback: nil) }

    before do
      expect(stub).to receive(:callback).with(space)
    end
    it 'yields to block' do
      subject.with_space do |space|
        stub.callback(space)
      end
    end
  end

  describe '#with_editor_interfaces' do
    let(:client) { double(:client, editor_interfaces: double(:editor_interfaces)) }
    subject { described_class.new(name, version, client, space) }

    let(:stub) { double(:stub, callback: nil) }

    before do
      expect(stub).to receive(:callback).with(client.editor_interfaces)
    end

    it 'yields to block' do
      subject.with_editor_interfaces do |space|
        stub.callback(space)
      end
    end
  end

  describe '#record_migration' do
    subject { described_class.new(name, version, client, space) }

    let(:migration_content_type) { double(:migration_content_type) }
    let(:entries) { double(:entries) }
    let(:entry) { double(:entry) }

    before do
      expect(migration_content_type).to receive(:entries).and_return(entries)
      expect(entries).to receive(:create).with(version: version).and_return(entry)
      expect(entry).to receive(:save)
      expect(entry).to receive(:publish)
    end

    it 'publishes to contentful' do
      expect(subject.record_migration(migration_content_type)).to eq(entry)
    end
  end

  describe '#erase_migration' do
    subject { described_class.new(name, version, client, space) }

    let(:migration_content_type) { double(:migration_content_type) }
    let(:entries) { double(:entries) }
    let(:all) { [entry] }
    let(:entry) { double(:entry, version: version) }
    context 'when migration found' do
      before do
        expect(migration_content_type).to receive(:entries).and_return(entries)
        expect(entries).to receive(:all).and_return(all)
        expect(entry).to receive(:unpublish)
        expect(entry).to receive(:destroy)
      end

      it 'publishes to contentful' do
        expect(subject.erase_migration(migration_content_type)).to eq(entry)
      end
    end
    context 'when not migration found' do
      let(:entry) { nil }

      before do
        expect(migration_content_type).to receive(:entries).and_return(entries)
        expect(entries).to receive(:all).and_return([])
      end

      it 'publishes to contentful' do
        expect(subject.erase_migration(migration_content_type)).to eq(nil)
      end
    end
  end
end
