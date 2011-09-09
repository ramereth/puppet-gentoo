require 'puppet/provider/portagefile'

Puppet::Type.type(:package_keywords).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.keywords/default",
  :filetype => :flat
) do

  desc "The package_keywords provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name keywords},
    :joiner => ' ',
    :rts  => true do |line|
    hash = {}
    # if we have a package and a keyword
    if line =~ /^(\S+)\s+(.*)\s*$/
      hash[:name] = $1
      keywords = $2

      if keywords
        hash[:keywords] = keywords.split(/\s+/)
      end
    # just a package
    elsif line =~ /^(\S+)\s*$/
      hash[:name] = $1
    else
      raise Puppet::Error, "Could not match '#{line}'"
    end

    if hash[:keywords] == ""
      hash.delete(:keywords)
    end

    hash
  end

  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed
    build_line(hash, :keywords)
  end
end
