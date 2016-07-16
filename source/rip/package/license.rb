module Rip::Package
  class License
    OSI_LICENSES = Rip::Package.root.join('source/osi_licenses.txt').read.lines.map(&:strip)
    KNOWN_LICENSES = [
      'proprietary'
    ] + OSI_LICENSES

    attr_reader :name
    attr_reader :path

    def initialize(name, path, is_osi)
      @name = name
      @path = path
      @is_osi = is_osi
    end

    def osi?
      @is_osi
    end

    def self.extract(license)
      case license
      when Pathname
        raise Rip::Package::InvalidMetadata, 'path to license_file not valid' unless license.file?
        new(license.basename.to_s, license, false)
      when String
        raise Rip::Package::InvalidMetadata, 'invalid or unknown license' unless known_license?(license)
        new(license, nil, true)
      end
    end

    def self.known_license?(license_name)
      KNOWN_LICENSES.include?(license_name)
    end
  end
end
