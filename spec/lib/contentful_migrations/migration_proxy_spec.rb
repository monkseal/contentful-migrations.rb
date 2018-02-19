RSpec.describe ContentfulMigrations::MigrationProxy do
  let(:version) { '20180216021826' }
  let(:filename) { 'spec/db/contentful_migrations/20180216021826_build_test_content.rb' }
  let(:name) { 'BuildTestContent' }

  subject { described_class.new(name, version, filename, nil) }

  it 'creates delegate methods' do
    expect(subject).to respond_to(:migrate)
    expect(subject).to respond_to(:record_migration)
    expect(subject).to respond_to(:erase_migration)
  end

  describe '#basename' do
    it 'returns basename of file' do
      expect(subject.basename).to eq('20180216021826_build_test_content.rb')
    end
  end

  describe '#load_migration' do
    it 'loads migration class' do
      expect(subject.send(:load_migration).class.to_s).to eq('BuildTestContent')
    end
  end
end
