require 'puppet/provider/parsedfile'
 
Puppet::Type.type(:package_keywords).provide(:parsed,
    :parent => Puppet::Provider::ParsedFile,
    :default_target => "/etc/portage/package.keywords/default",
    :filetype => :flat
) do

    desc "The package_keywords provider that uses the ParsedFile class"
 
    text_line :comment, :match => /^#/;
    text_line :blank, :match => /^\s*$/;
 
    record_line :parsed, :fields => %w{name keywords},
        :joiner => ' ',
        :rts    => true do |line|
        hash = {}
        # if we have a package & and a keyword
        if line.sub!(/^(\S+)\s+(.*)\s*$/, '')
            hash[:name] = $1
            keywords = $2

            unless keywords == ""
                hash[:keywords] = keywords.split(/\s+/)
            end
        # just a package
        elsif line.sub!(/^(\S+)\s*$/, '')
            hash[:name] = $1
        else
            raise Puppet::Error, "Could not match '%s'" % line
        end
 
        if hash[:keywords] == ""
            hash.delete(:keywords)
        end
 
        return hash
    end

    def flush
        # Ensure the target directory exists before creating file
        unless File.exist?(dir = File.dirname(target))
            Dir.mkdir(dir)
        end
        super
    end

    def self.to_line(hash)
        return super unless hash[:record_type] == :parsed
        unless hash[:name] and hash[:name] != :absent
            raise ArgumentError, "package is a required attribute for package_keywords"
        end

        str = hash[:name]

        if hash.include? :keywords
            if hash[:keywords].is_a? Array
                str += " %s" % hash[:keywords].join(" ")
            else
                str += " %s" % hash[:keywords]
            end
        end

        str
    end
    
end
