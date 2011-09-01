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
            raise ArgumentError, "name is a required attribute for package_keywords"
        end

        str = hash[:name]

        if hash.include? :keywords
            if hash[:keywords].is_a? Array
                str << " " << hash[:keywords].join(" ")
            else
                str << " " << hash[:keywords]
            end
        end
        str
    end
end
