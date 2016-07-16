require 'hashie'

module Rip::Package
  class Metadata
    attr_reader :authors
    attr_reader :dependencies
    attr_reader :description
    attr_reader :executables
    attr_reader :homepage
    attr_reader :license
    attr_reader :extra
    attr_reader :name
    attr_reader :version

    def initialize(author: nil, authors: nil, dependencies: {}, description: nil, executables: {}, homepage: nil, license: nil, license_file: nil, extra: nil, name:, version:)
      raise Rip::Package::InvalidMetadata, 'an author is required' if author.nil? && authors.nil?
      raise Rip::Package::InvalidMetadata, 'must use `[[authors]]` when specifying more than one author' if author && authors
      @authors = Rip::Package::Author.extract(author ? [ author ] : authors)

      @dependencies = Rip::Package::Dependency.extract(dependencies)

      @description = description

      @executables = Rip::Package::Executable.extract(executables)

      @homepage = URI.parse(homepage) if homepage

      raise Rip::Package::InvalidMetadata, 'a license is required' if license.nil? && license_file.nil?
      raise Rip::Package::InvalidMetadata, 'must specify a single license' if license && license_file
      @license = if license_file
        Rip::Package::License.extract(Pathname.new(license_file).expand_path)
      else
        Rip::Package::License.extract(license)
      end

      @extra = Hashie::Mash.new(extra) if extra

      raise Rip::Package::InvalidMetadata, '`name` must follow the rules for references' unless /\A[a-zA-Z_]+\z/ =~ name
      @name = name

      @version = Rip::Package::Version.extract(version)
    end
  end
end
