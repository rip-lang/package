module Rip::Package
  class Dependency
    attr_reader :name

    def initialize(name)
      @name = name
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
    attr_reader :version
    attr_reader :vary
    attr_reader :repository

    def initialize(name, version:, vary: 'minor', exact: false, repository: nil)
      super(name)
      @version = Rip::Package::Version.extract(version)
      @vary = vary
      @is_exact = exact
      @repository = repository
    end

    def exact?
      @is_exact
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
  end

  class PathDependency < Dependency
    attr_reader :package_root

    def initialize(name, package_root:, path:)
      super(name)
      @package_root = package_root.join(path).expand_path
    end
  end
end
