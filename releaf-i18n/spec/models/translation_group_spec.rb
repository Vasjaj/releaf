require "spec_helper"

describe I18n::Backend::Releaf::TranslationGroup do

  it { should validate_presence_of(:scope) }
  it { should validate_uniqueness_of(:scope) }
  it { should ensure_length_of(:scope).is_at_most(255) }
  it { should have_many(:translations).dependent(:destroy) }
  it { should accept_nested_attributes_for(:translations).allow_destroy(true) }

  before do
    @group = FactoryGirl.create(:translation_group, :scope => 'test')
  end

  describe "#to_s" do
    it "returns scope" do
      expect(@group.to_s).to eq('test')
    end
  end

  describe "translation group" do
    before do
      FactoryGirl.create(:translation, :key => 'test.yumberry', :translation_group => @group)
      FactoryGirl.create(:translation, :key => 'test.apple', :translation_group => @group)
      FactoryGirl.create(:translation, :key => 'test.orange', :translation_group => @group)
    end

    it "has relation to translations" do
      expect(@group.translations.size).to eq(3)
    end

    it "has translations ordered by key" do
      expect(@group.translations[0].key).to eq('test.apple')
      expect(@group.translations[1].key).to eq('test.orange')
      expect(@group.translations[2].key).to eq('test.yumberry')
    end

    it "destroys translations when destroying group itself" do
      expect { @group.destroy }.to change { I18n::Backend::Releaf::Translation.count }.from(3).to(0)
    end
  end
end