module Rip::Package
  class Dependency
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def inspect
      "#<#{self.class.name} #{to_s}>"
    end

    def self.extract(dependencies)
      dependencies.map do |name, options|
        expand_constraints(name, options)
      end
    end

    protected

    def self.expand_constraints(name, options)
      case
      when options.include?(:version)
        Rip::Package::VersionDependency.new(name, options)
      when options.include?(:git)
        Rip::Package::GitDependency.new(name, options)
      when options.include?(:path)
        Rip::Package::PathDependency.new(name, options)
      end
    end
  end

  class VersionDependency < Dependency
    VARY_OPTIONS = [
      :major,
      :minor,
      :patch,
      :pre_release,
      :build,
      :exact
    ]

    attr_reader :version
    attr_reader :vary
    attr_reader :repository

    def initialize(name, version:, vary: :minor, repository: nil)
      raise Rip::Package::InvalidMetadata, "`vary` must be one of #{VARY_OPTIONS.join(', ')} exactly" unless VARY_OPTIONS.include?(vary.to_sym)
      super(name)
      @version = Rip::Package::Version.extract(version)
      @vary = vary.to_sym
      @repository = repository
    end

    def to_s
      repo = " #{repository}" if repository
      "#{name} #{version} [#{vary}]#{repo}"
    end
  end

  class GitDependency < Dependency
    attr_reader :repository
    attr_reader :commit

    def initialize(name, git:, commit: 'master')
      super(name)
      @repository = git
      @commit = commit
    end

    def to_s
      "#{name} #{repository}##{commit}"
    end
  end

  class PathDependency < Dependency
    attr_reader :package_root

    def initialize(name, package_root:, path:)
      super(name)
      @package_root = package_root.join(path).expand_path
    end

    def to_s
      "#{name} #{package_root}"
    end
  end
end
