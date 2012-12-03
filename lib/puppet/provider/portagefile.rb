# Common base class for gentoo package_* providers. It aggregates some of the
# boilerplate that's shared between the providers.
require 'puppet/provider/parsedfile'
class Puppet::Provider::PortageFile < Puppet::Provider::ParsedFile

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;

  def flush
    # Ensure the target directory exists before creating file
    unless File.exist?(dir = File.dirname(target))
      Dir.mkdir(dir)
    end
    super
  end

  def self.build_line(hash, sym)
    unless hash[:name] and hash[:name] != :absent
      raise ArgumentError, "name is a required attribute of portagefile providers"
    end

    str = hash[:name]

    if hash.include? sym
      if hash[sym].is_a? Array
        str << " " << hash[sym].join(" ")
      else
        str << " " << hash[sym]
      end
    end
    str
  end
end
