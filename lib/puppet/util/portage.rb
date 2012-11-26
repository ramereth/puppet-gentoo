module Puppet::Util::Portage
  # Util methods for Portage types and providers.

  # Determine if a string is a valid DEPEND atom
  #
  # @param atom [String] The string to validate as a DEPEND atom
  #
  # @return [TrueClass]
  # @return [FalseClass]
  #
  # @see http://www.linuxmanpages.com/man5/ebuild.5.php#lbAE 'man 5 ebuild section DEPEND'
  def self.valid_atom?(atom)
    atom_prefix  = '(?:[<>=]|[<>]=)'
    atom_name    = '(?:[a-zA-Z-]+/[a-zA-Z-]+?)'
    atom_version = '(?:-[\d.]+[\w-]+)'

    base_atom      = Regexp.new("^#{atom_name}$")
    versioned_atom = Regexp.new("^#{atom_prefix}#{atom_name}#{atom_version}$")
    depend         = Regexp.union(base_atom, versioned_atom)

    # Normalize the regular expression output to a boolean
    !!(atom =~ depend)
  end
end
