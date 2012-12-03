Puppet::Type.newtype(:package_unmask) do
  @doc = "Unmask packages in portage.
  
      package_unmask { 'app-admin/puppet-2.7.1':
        target  => 'puppet',
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

  newproperty(:target) do
    desc "The location of the package.unmask file"

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
        value = "/etc/portage/package.unmask/" + value
      end
      value
    end
  end
end
