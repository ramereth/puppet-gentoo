#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

provider_class = Puppet::Type.type(:package_use).provider(:parsed)

describe provider_class do
  before do
    @provider = provider_class
    @provider.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    @provider.stubs(:filetype=)
    @default_target = @provider.default_target
  end

  it "should have a default target of /etc/portage/package.use/default" do
    @provider.default_target.should == "/etc/portage/package.use/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree doc"
      @provider.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should not raise an error if no use flags are given for a package" do
      line = "app-admin/tree"
      lambda { @provider.parse_line(line) }.should_not raise_error
    end

    it "should parse out a single use flag" do
      line = "app-admin/tree doc"
      @provider.parse_line(line)[:use_flags].should == %w{doc}
    end

    it "should parse out multiple use flags into an array" do
      line = "app-admin/tree doc -debug"
      @provider.parse_line(line)[:use_flags].should == %w{doc -debug}
    end
  end
  
  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.use').returns(true)
      @provider.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_use.new(:name => 'app-admin/tree')
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

    it "should write a single use to disk" do
      @providerinstance.use_flags = "doc"
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree doc\n"
    end

    it "should write an array of use to disk" do
      @providerinstance.use_flags = %w{doc bin}
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree doc bin\n"
    end
  end
end
