require 'puppet/provider/parsedfile'
 
Puppet::Type.type(:package_mask).provide(:parsed,
    :parent => Puppet::Provider::ParsedFile,
    :default_target => "/etc/portage/package.mask/default",
    :filetype => :flat
) do

  desc "The package_mask provider backed by parsedfile"
 
  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;
 
  record_line :parsed, :fields => %w{name}, :rts => true

  def flush
    # Ensure the target directory exists before creating file
    unless File.exist?(dir = File.dirname(target))
      Dir.mkdir(dir)
    end
    super
  end
end
