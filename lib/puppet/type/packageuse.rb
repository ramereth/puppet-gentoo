Puppet::Type.newtype(:packageuse) do
    @doc = "Set use flags for a package
    
            packageuse { 'app-admin/puppet':
                use_flags => ['augeas', '-rrdtool'],
            }"

    ensurable

    newparam(:package, :namevar => true) do
        desc "The package"
    end

    newproperty(:use_flags) do
        desc "The flag use flag(s) to apply"

        validate do |value|
            raise Puppet::Error, "Use Flag cannot contain whitespace" if value =~ /\s/
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
        desc "The location of the package.use file"

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
                value = "/etc/portage/package.use/" + value
            end
            value
        end

    end

end
