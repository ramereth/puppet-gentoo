Puppet::Type.newtype(:packageuse) do
    @doc = "Set use flags for a package
    
            packageuse { 'app-admin/puppet':
                use_flags => ['augeas', '-rrdtool'],
            }"

    ensurable

    newparam(:package, :namevar => true) do
        desc "The package"
    end

    #newproperty(:package) do
    #    desc "The package to which the use flag should be applied"
    #end

    newproperty(:use_flags) do
        desc "The flag use flag(s) to apply"

        validate do |value|
            raise Puppet::Error, "Use Flag cannot contain whitespace" if value =~ /\s/
        end

        def insync?(is)
            is == @should
        end

        #def retrieve
        #    is = super
        #    case is
        #    when String
        #        is.split(/\s*,\s*/)
        #    when Symbol
        #        is = [is]
        #    when Array
        #        # nothing
        #    else
        #        raise Puppet::DevError, "Invalid @is type %s" % is.class
        #    end
        #    return is
        #end
              
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
                @resource.class.defaultprovider.ancestors.include? (Puppet::Provider::ParsedFile)
                @resource.class.defaultprovider.default_target
            else
                nil
            end
        }

        # Allow us to not have to specify a whole path unless we really want to
        munge do |value|
            if !value.match(/^\/etc\/portage\/package.use\//)
                value = "/etc/portage/package.use/" + value
            end
            value
        end

    end

end
