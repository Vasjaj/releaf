require 'spec_helper'

describe Releaf::ApplicationHelper do
  Color = Struct.new(:id, :to_s)

  before do
    group = FactoryGirl.create(:translation_group, :scope => "admin.global")
    translation = FactoryGirl.create(:translation, :key => "admin.global.colors-red", :translation_group => group)
    FactoryGirl.create(:translation_data, :lang => "en", :localization => "Color red", :translation => translation)
    Settings.i18n_updated_at = Time.now

    helper.stub(:controller_scope_name).and_return("admin.global")
  end

  describe "#i18n_options_for_select" do
    it "returns translated options for given array of string" do
      input = ["red", "green", "blue"]
      output = ['<option value="red">Color red</option>', '<option value="green" selected="selected">green</option>', '<option value="blue">blue</option>'].join("\n")
      helper.i18n_options_for_select(input, "green", "colors").should eq(output)
    end

    it "returns translated options for given array of objects" do
      input = [Color.new(1, "red"), Color.new(2, "green"), Color.new(3, "blue")]
      output = ['<option value="1">Color red</option>', '<option value="2" selected="selected">green</option>', '<option value="3">blue</option>'].join("\n")
      helper.i18n_options_for_select(input, 2, "colors").should eq(output)
    end

    it "returns translated options for given simple hash" do
      input = {"r" => "red", "g" => "green", "b" => "blue"}
      output = ['<option value="r">Color red</option>', '<option value="g" selected="selected">green</option>', '<option value="b">blue</option>'].join("\n")
      helper.i18n_options_for_select(input, "g", "colors").should eq(output)
    end

    it "returns translated options for given hash of objects" do
      input = {"r" => Color.new(1, "red"), "g" => Color.new(2, "green"), "b" => Color.new(3, "blue")}
      output = ['<option value="1">Color red</option>', '<option value="2" selected="selected">green</option>', '<option value="3">blue</option>'].join("\n")
      helper.i18n_options_for_select(input, 2, "colors").should eq(output)
    end

    it "returns translated options for given array of string for another translation scope" do
      input = ["red", "green", "blue"]
      output = ['<option value="red">red</option>', '<option value="green" selected="selected">green</option>', '<option value="blue">blue</option>'].join("\n")
      helper.i18n_options_for_select(input, "green", "colors", {:scope => "admin.products"}).should eq(output)
    end

    it "should raise ArgumentError" do
      expect{ helper.i18n_options_for_select("asdasd", 2, "colors")}.to raise_error(ArgumentError, "unsupported container class: String")
    end
  end
end