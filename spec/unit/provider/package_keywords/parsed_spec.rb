#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

provider_class = Puppet::Type.type(:package_keywords).provider(:parsed)

describe provider_class do
  before do
    @provider = provider_class
    @provider.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    @provider.stubs(:filetype=)
    @default_target = @provider.default_target
  end

  it "should have a default target of /etc/portage/package.keywords/default" do
    @provider.default_target.should == "/etc/portage/package.keywords/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree ~amd64"
      @provider.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should not raise an error if no keywords are given for a package" do
      line = "app-admin/tree"
      lambda { @provider.parse_line(line) }.should_not raise_error
    end

    it "should parse out a single keywords" do
      line = "app-admin/tree ~amd64"
      @provider.parse_line(line)[:keywords].should == %w{~amd64}
    end

    it "should parse out multiple keywords into an array" do
      line = "app-admin/tree -amd64 ~amd64"
      @provider.parse_line(line)[:keywords].should == %w{-amd64 ~amd64}
    end
  end

  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.keywords').returns(true)
      @provider.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_keywords.new(:name => 'app-admin/tree', :ensure => :present)
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

    it "should write a single keyword to disk" do
      @providerinstance.keywords = "~amd64"
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree ~amd64\n"
    end

    it "should write an array of keywords to disk" do
      @providerinstance.keywords = %w{~amd64 ~x86}
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree ~amd64 ~x86\n"
    end
  end
end
