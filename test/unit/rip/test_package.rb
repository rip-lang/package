require_relative '../../test_helper'

describe Rip::Package do
  let(:fixtures) { Rip::Package.root + 'test' + 'fixtures' }
  let(:metadata) { Rip::Package.load_file(fixtures + metadata_name) }

  describe '.load_file' do
    describe 'simple package' do
      let(:metadata_name) { 'minimal.toml' }

      specify { expect(metadata.name).must_equal('foo') }

      specify { expect(metadata.version.major).must_equal(1) }
      specify { expect(metadata.version.minor).must_equal(2) }
      specify { expect(metadata.version.patch).must_equal(3) }

      specify { expect(metadata.license.name).must_equal('MIT') }
      specify { expect(metadata.license).must_be(:osi?) }

      specify { expect(metadata.authors.count).must_equal(1) }
      specify { expect(metadata.authors.first.name).must_equal('Thomas Ingram') }
      specify { expect(metadata.authors.first.email).must_equal('author@example.com') }

      specify { expect(metadata.homepage).must_be_nil }

      specify { expect(metadata.description).must_be_nil }

      specify { expect(metadata.executables.count).must_equal(0) }

      specify { expect(metadata.extra).must_be_nil }

      specify { expect(metadata.dependencies.count).must_equal(0) }
    end

    describe 'complex package' do
      let(:metadata_name) { 'full.toml' }

      specify { expect(metadata.name).must_equal('mighty_foo') }

      specify { expect(metadata.version.major).must_equal(1) }
      specify { expect(metadata.version.minor).must_equal(3) }
      specify { expect(metadata.version.patch).must_equal(8) }

      specify { expect(metadata.license.name).must_equal('LICENSE.txt') }
      specify { expect(metadata.license.path).must_equal(fixtures + 'LICENSE.txt') }
      specify { expect(metadata.license).wont_be(:osi?) }

      specify { expect(metadata.authors.count).must_equal(2) }
      specify { expect(metadata.authors.first.name).must_equal('Thomas Ingram') }
      specify { expect(metadata.authors.last.email).must_equal('second@example.com') }

      specify { expect(metadata.homepage).wont_be_nil }

      specify { expect(metadata.description).wont_be_nil }

      specify { expect(metadata.executables.count).must_equal(1) }

      specify { expect(metadata.extra).wont_be_nil }
      specify { expect(metadata.extra).must_be_kind_of(Hashie::Mash) }
      specify { expect(metadata.extra).must_include(:answer) }

      specify { expect(metadata.dependencies.count).must_equal(10) }
    end
  end
end
