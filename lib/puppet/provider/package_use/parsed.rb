require 'puppet/provider/parsedfile'
 
Puppet::Type.type(:package_use).provide(:parsed,
    :parent => Puppet::Provider::PortageFile,
    :default_target => "/etc/portage/package.use/default",
    :filetype => :flat
) do

    desc "The package_use provider that uses the ParsedFile class"
 
    record_line :parsed, :fields => %w{name use_flags},
        :joiner => ' ',
        :rts    => true do |line|
        hash = {}
        if line =~ /^(\S+)\s+(.*)\s*$/
            hash[:name] = $1
            use_flags = $2

            unless use_flags == ""
                hash[:use_flags] = use_flags.split(/\s+/)
            end
        # just a package
        elsif line =~ /^(\S+)\s*/
            hash[:name] = $1
        else
            raise Puppet::Error, "Could not match '%s'" % line
        end
 
        if hash[:use_flags] == ""
            hash.delete(:use_flags)
        end
 
        hash
    end

    def self.to_line(hash)
        return super unless hash[:record_type] == :parsed
        unless hash[:name] and hash[:name] != :absent
            raise ArgumentError, "name is a required attribute for package_use"
        end

        str = hash[:name]

        if hash.include? :use_flags
            if hash[:use_flags].is_a? Array
                str << " " << hash[:use_flags].join(" ")
            else
                str << " " << hash[:use_flags]
            end
        end
        str
    end
end
