module Puppet::Util::Portage
  def self.valid_atom? atom
    atom_prefix  = %r{[<>=]|[<>]=}
    atom_name    = %r{[a-zA-Z-]+/[a-zA-Z-]+?}
    atom_version = %r{-[\d.]+[\w-]+}
    
    base_atom = Regexp.new("^" + atom_name.to_s + "$")
    versioned_atom = Regexp.new("^" + atom_prefix.to_s + atom_name.to_s + atom_version.to_s + "$")

    (atom =~ base_atom or atom =~ versioned_atom)
  end
end
