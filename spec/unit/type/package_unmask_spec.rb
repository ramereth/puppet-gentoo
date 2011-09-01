#!/usr/bin/env rspec
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

type_class = Puppet::Type.type(:package_unmask)

describe type_class do
  before do
    @class    = type_class
    @provider = stub 'provider'
    @provider.stubs(:name).returns(:parsed)
    @provider.stubs(:ancestors).returns([Puppet::Provider::ParsedFile])
    @provider.stubs(:default_target).returns("defaulttarget")
    @class.stubs(:defaultprovider).returns(@provider)
  end

  describe "when validating attributes" do
    params     = [:name]
    properties = [:target, :ensure]

    params.each do |param|
      it "should have the #{param} param" do
        @class.attrtype(param).should == :param
      end
    end

    properties.each do |property|
      it "should have the #{property} property" do
        @class.attrtype(property).should == :property
      end
    end
  end

  it "should have name as the namevar" do
    @class.key_attributes.should == [:name]
  end

  describe "when validating the target property" do
    it "should default to the provider's default target" do
      @class.new(:name => "sys-devel/gcc").should(:target).should == "/etc/portage/package.unmask/defaulttarget"
    end

    it "should munge targets that do not specify a fully qualified path" do
      @class.new(:name => "sys-devel/gcc", :target => "gcc").should(:target).should == "/etc/portage/package.unmask/gcc"
    end

    it "should not munge fully qualified targets" do
      @class.new(:name => "sys-devel/gcc", :target => "/tmp/gcc").should(:target).should == "/tmp/gcc"
    end
  end
end
