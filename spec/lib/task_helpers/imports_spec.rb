describe TaskHelpers::Imports do
  describe '.validate_source' do
    before(:each) do
      @import_dir = Dir.mktmpdir('miq_imp_dir')
      @import_dir2 = Dir.mktmpdir('miq_imp_dir')
      FileUtils.remove_entry @import_dir2
      @import_file = Tempfile.new('miq_imp_file')
    end

    after(:each) do
      FileUtils.remove_entry @import_dir
      @import_file.close!
    end

    it 'is a directory and readable' do
      expect(TaskHelpers::Imports.validate_source(@import_dir)).to be_nil
    end

    it 'is a file and readable' do
      expect(TaskHelpers::Imports.validate_source(@import_file)).to be_nil
    end

    it 'does not exist' do
      expect(TaskHelpers::Imports.validate_source(@import_dir2)).to eq('Import source must be a filename or directory')
    end

    # rubocop:disable Style/NumericLiteralPrefix
    it 'is a directory not readable' do
      File.chmod(0300, @import_dir)
      expect(TaskHelpers::Imports.validate_source(@import_dir)).to eq('Import source is not readable')
      File.chmod(0700, @import_dir)
    end

    it 'is a file not readable' do
      File.chmod(0200, @import_file)
      expect(TaskHelpers::Imports.validate_source(@import_file)).to eq('Import source is not readable')
      File.chmod(0600, @import_file)
    end
    # rubocop:enable Style/NumericLiteralPrefix
  end
end
