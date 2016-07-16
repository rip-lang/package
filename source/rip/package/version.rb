require 'semverse'

module Rip::Package
  class Version
    attr_reader :major
    attr_reader :minor
    attr_reader :patch
    attr_reader :pre_release
    attr_reader :build

    def initialize(parts)
      @major = parts.major
      @minor = parts.minor
      @patch = parts.patch
      @pre_release = parts.pre_release
      @build = parts.build
    end

    def self.extract(version)
      begin
        new(Semverse::Version.new(version))
      rescue Semverse::InvalidVersionFormat
        raise Rip::Package::InvalidMetadata, '`version` must follow semver'
      end
    end
  end
end
