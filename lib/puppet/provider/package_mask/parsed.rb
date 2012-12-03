# Trivial provider for managing a list of depend atoms to mask
require 'puppet/provider/portagefile'

Puppet::Type.type(:package_mask).provide(:parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => "/etc/portage/package.mask/default",
  :filetype => :flat
) do

  desc "The package_mask provider backed by parsedfile"
  record_line :parsed, :fields => %w{name}, :rts => true
end
