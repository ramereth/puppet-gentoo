require 'puppet/provider/parsedfile'
class Puppet::Provider::PortageFile < Puppet::Provider::ParsedFile

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;

  def flush
      # Ensure the target directory exists before creating file
      unless File.exist?(dir = File.dirname(target))
          Dir.mkdir(dir)
      end
      super
  end
end
