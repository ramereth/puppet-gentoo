# baselayout_version.rb
Facter.add("baselayout_version") do
    confine :operatingsystem => :gentoo
    setcode do
        %x{eix '-I*' --format '<installedversions:VERSION>' baselayout}.chomp
    end
end
