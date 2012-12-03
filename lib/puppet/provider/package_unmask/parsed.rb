# Trivial provider for managing a list of depend atoms to unmask
require 'puppet/provider/portagefile'

Puppet::Type.type(:package_unmask).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.unmask/default",
  :filetype => :flat
) do

  desc "The package_unmask provider backed by parsedfile"
  record_line :parsed, :fields => %w{name}, :rts => true
end
