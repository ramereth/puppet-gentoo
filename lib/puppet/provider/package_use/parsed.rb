require 'puppet/util/portage'
require 'puppet/provider/portagefile'

Puppet::Type.type(:package_use).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.use/default",
  :filetype => :flat
) do

  desc "The package_use provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name use},
    :joiner => ' ',
    :rts  => true do |line|
    hash = {}
    if line =~ /^(\S+)\s+(.*)\s*$/
      hash[:name] = $1
      use = $2

      unless use == ""
        hash[:use] = use.split(/\s+/)
      end
    # just a package
    elsif line =~ /^(\S+)\s*/
      hash[:name] = $1
    else
      raise Puppet::Error, "Could not match '%s'" % line
    end

    if hash[:use] == ""
      hash.delete(:use)
    end

    hash
  end

  def self.to_line(hash)
    build_line(hash, :use)
  end
end
