module Rip::Package
  class Executable
    attr_reader :root_module
    attr_reader :output

    def initialize(root_module, output)
      @root_module = root_module
      @output = output
    end

    def inspect
      "#<#{self.class.name} #{to_s}>"
    end

    def to_s
      "#{root_module} => #{output}"
    end

    def self.extract(executables)
      project_root = executables.delete(:_package_root)

      executables.map do |root_module, output|
        new(
          project_root.join(root_module.to_s).expand_path,
          project_root.join(output.to_s).expand_path
        )
      end
    end
  end
end
