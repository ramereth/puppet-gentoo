#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Puppet::Util::Portage do
  describe "when validating atoms" do

    valid_atoms   = %w{=sys-devel/gcc-4.3.2-r4 >=app-crypt/gnupg-1.9 net-analyzer/nagios-nrpe}
    invalid_atoms = %w{sys-devel-gcc =sys-devel/gcc}

    valid_atoms.each do |atom|
      it "should accept #{atom} as a valid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_true
      end
    end

    invalid_atoms.each do |atom|
      it "should reject #{atom} as an invalid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_false
      end
    end
  end
end
