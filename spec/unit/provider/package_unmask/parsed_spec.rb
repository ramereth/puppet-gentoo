#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

provider_class = Puppet::Type.type(:package_unmask).provider(:parsed)

describe provider_class do
  before do
    @provider = provider_class
    @provider.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    @provider.stubs(:filetype=)
    @default_target = @provider.default_target
  end

  it "should have a default target of /etc/portage/package.unmask/default" do
    @provider.default_target.should == "/etc/portage/package.unmask/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree"
      @provider.parse_line(line)[:name].should == "app-admin/tree"
    end
  end

  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.unmask').returns(true)
      @provider.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_unmask.new(:name => 'app-admin/tree')
      resource.stubs(:should).with(:target).returns(@default_target)

      @providerinstance = @provider.new(resource)
      @providerinstance.ensure = :present
    end

    after :each do
      @provider.clear
    end

    it "should write an atom name to disk" do
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree\n"
    end
  end
end
