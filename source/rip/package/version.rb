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

    def inspect
      "#<#{self.class.name} #{to_s}>"
    end

    def to_s
      base = "#{major}.#{minor}.#{patch}"

      case
      when pre_release && build
        "#{base}-#{pre_release}+#{build}"
      when pre_release
        "#{base}-#{pre_release}"
      when build
        "#{base}+#{build}"
      else
        base
      end
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
