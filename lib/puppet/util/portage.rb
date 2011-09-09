# module: Puppet::Util::Portage
#
# Contains DEPEND atom validation.
module Puppet::Util::Portage
  def self.valid_atom? atom
    atom_prefix  = %r{[<>=]|[<>]=}
    atom_name    = %r{[a-zA-Z-]+/[a-zA-Z-]+?}
    atom_version = %r{-[\d.]+[\w-]+}
    
    base_atom = Regexp.new("^" + atom_name.to_s + "$")
    versioned_atom = Regexp.new("^" + atom_prefix.to_s + atom_name.to_s + atom_version.to_s + "$")
    depend = Regexp.union(base_atom, versioned_atom)

    atom =~ depend
  end
end
