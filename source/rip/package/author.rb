module Rip::Package
  class Author
    attr_reader :name
    attr_reader :email

    def initialize(name:, email:)
      raise Rip::Package::InvalidMetadata, 'author `name` is required' if name.nil?
      raise Rip::Package::InvalidMetadata, 'author `email` is required' if email.nil?

      @name = name
      @email = email
    end

    def inspect
      "#<#{self.class.name} #{to_s}>"
    end

    def to_s
      "\"#{name}\" <#{email}>"
    end

    def self.extract(authors)
      authors.map(&method(:new))
    end
  end
end
