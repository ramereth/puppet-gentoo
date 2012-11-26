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
    atom_prefix  = %r{[<>=]|[<>]=}
    atom_name    = %r{[a-zA-Z-]+/[a-zA-Z-]+?}
    atom_version = %r{-[\d.]+[\w-]+}

    base_atom = Regexp.new("^" + atom_name.to_s + "$")
    versioned_atom = Regexp.new("^" + atom_prefix.to_s + atom_name.to_s + atom_version.to_s + "$")
    depend = Regexp.union(base_atom, versioned_atom)

    atom =~ depend
  end
end
