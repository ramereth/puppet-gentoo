Puppet::Type.newtype(:package_use) do
  @doc = "Set use flags for a package.

      package_use { 'app-admin/puppet':
        use    => ['augeas', '-rrdtool'],
        target => 'puppet',
      }"

  ensurable

  newparam(:name) do
    desc "The package name"

    isnamevar

    validate do |value|

      unless Puppet::Util::Portage.valid_atom? value
        raise Puppet::Error, "name must be a properly formatted atom, see portage(5) for more information"
      end
    end
  end

  newproperty(:use) do
    desc "The flag use flag(s) to apply"

    validate do |value|
      raise Puppet::Error, "Use flag cannot contain whitespace" if value =~ /\s/
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

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      if !value.match(/\//)
        value = "/etc/portage/package.use/" + value
      end
      value
    end
  end
end
