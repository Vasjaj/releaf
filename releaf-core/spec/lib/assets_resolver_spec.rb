require "spec_helper"

describe Releaf::AssetsResolver do
  before do
    described_class.class_variable_set(:@@list, nil)
  end

  describe ".controller_assets" do
    it "returns array with controller specific asset alognside releaf/application" do
      expect(described_class.controller_assets("releaf/i18n_database/translations", :javascripts))
        .to eq(["releaf/application", "releaf/controllers/releaf/i18n_database/translations"])
      expect(described_class.controller_assets("releaf/i18n_database/translations", :stylesheets))
        .to eq(["releaf/application", "releaf/controllers/releaf/i18n_database/translations"])
    end

    context "when no controller specific assets exists" do
      it "returns only releaf/application" do
        allow(described_class).to receive(:list).and_return({})
        expect(described_class.controller_assets("releaf/i18n_database/translations", :stylesheets))
          .to eq(["releaf/application"])
      end
    end
  end

  describe ".scan" do
    it "returns array with controller scoped stylesheets and javascripts" do
      list = {
        "releaf/content/nodes"=>{:stylesheets=>["releaf/controllers/releaf/content/nodes"],
                                 :javascripts=>["releaf/controllers/releaf/content/nodes"]},
        "releaf/permissions/roles"=>{:stylesheets=>["releaf/controllers/releaf/permissions/roles"],
                                     :javascripts=>[]},
        "releaf/i18n_database/translations"=>{:stylesheets=>["releaf/controllers/releaf/i18n_database/translations"],
                                              :javascripts=>["releaf/controllers/releaf/i18n_database/translations"]},
        "releaf/permissions/sessions" => {:stylesheets=>["releaf/controllers/releaf/permissions/sessions"], :javascripts=>[]}
      }
      expect(described_class.scan).to eq(list)
    end
  end

  describe ".list" do
    it "caches scan result" do
      expect(described_class).to receive(:scan).once.and_return("x")
      described_class.list
      described_class.list
    end

    it "return scan result" do
      allow(described_class).to receive(:scan).once.and_return("x")
      expect(described_class.list).to eq("x")
    end

    context "when within development mode" do
      it "does not cache scan result" do
        allow(Rails.env).to receive(:development?).and_return(true)
        expect(described_class).to receive(:scan).twice.and_return("x")
        expect(described_class.list).to eq("x")
        expect(described_class.list).to eq("x")
      end
    end
  end
end