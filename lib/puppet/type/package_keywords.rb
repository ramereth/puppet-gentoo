Puppet::Type.newtype(:package_keywords) do
    @doc = "Set keywords for a package
    
            package_keywords { 'app-admin/puppet':
                package   => 'app-admin/puppet',
                keywords  => ['~x86', '-hppa'],
            }"

    ensurable

    newproperty(:package) do
        desc "The package"

        isnamevar
    end

    newproperty(:keywords) do
        desc "The keywords(s) to use"

        validate do |value|
            raise Puppet::Error, "Keyword cannot contain whitespace" if value =~ /\s/
        end

        def insync?(is)
            is == @should
        end

        def should
            if defined? @should
                if @should == [:absent]
                    return :absent
                else
                    return @should
                end
            else
                return nil
            end
        end

        def should_to_s(newvalue = @should)
            newvalue.join(" ")
        end

        def is_to_s(currentvalue = @is)
            currentvalue = [currentvalue] unless currentvalue.is_a? Array
            currentvalue.join(" ")
        end

    end

    newproperty(:target) do
        desc "The location of the package.keywords file"

        defaultto {
            if
                @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
                @resource.class.defaultprovider.default_target
            else
                nil
            end
        }

        # Allow us to not have to specify an absolute path unless we really want to
        munge do |value|
            if !value.match(/\//)
                value = "/etc/portage/package.keywords/" + value
            end
            value
        end

    end

end
