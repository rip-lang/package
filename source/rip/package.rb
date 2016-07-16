require 'tomlrb'

module Rip
  module Package
    InvalidMetadata = Class.new(StandardError)

    def self.load_file(metadata_path)
      details = Tomlrb.load_file(metadata_path, symbolize_keys: true)
      package_root = Pathname.new(metadata_path).dirname

      if details.key?(:license_file) && !Pathname.new(details[:license_file]).absolute?
        details = details.merge(license_file: package_root.join(details[:license_file]).to_s)
      end

      if details.key?(:executables)
        details[:executables][:_package_root] = package_root
      end

      if details.key?(:dependencies)
        details[:dependencies] = details[:dependencies].map do |name, options|
          case options
          when String
            [ name, { version: options } ]
          when Hash
            _options = options.key?(:path) ? options.merge(package_root: package_root) : options
            [ name, _options ]
          end
        end
      end

      begin
        Rip::Package::Metadata.new(details)
      rescue ArgumentError
        raise Rip::Package::InvalidMetadata, 'invalid package metadata'
      end
    end

    def self.root
      Pathname.new(__dir__).parent.parent
    end
  end
end

require_relative './package/about'
require_relative './package/author'
require_relative './package/dependency'
require_relative './package/executable'
require_relative './package/license'
require_relative './package/metadata'
require_relative './package/version'
