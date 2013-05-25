require 'spec_helper'

describe Releaf::RolesController do
  before do
    auth_as_admin
    @role = Releaf::Role.first
  end

  it "should test roles custom fields and methods" do
    # index should contain only one role
    visit admin_roles_path
    page.should have_css('.primary_panel .body .releaf_table .tbody .row', :count => 1)

    # save new item and redirect to show view
    click_link "Create new item"
    within("form.new_resource") do
      fill_in("Name", :with => "second role")
      select(I18n.t("admin/books", :scope => 'admin.menu_items'), :from => 'Default controller')
      check(I18n.t("admin/books", :scope => 'admin.menu_items'))
      click_button 'Save'
    end
    new_role = Releaf::Role.last
    current_path.should eq(admin_role_path(new_role))

    # view should have all saved variables
    page.should have_css('.primary_panel .header h2', :text => "second role")
    page.should have_css('.primary_panel .body div[data-name="default_controller"] .value', :text => I18n.t("admin/books", :scope => 'admin.menu_items'))
    Releaf.available_admin_controllers.each do |controller|
      permission_value = (controller == "admin/books" ? "yes" : "no")
      page.should have_css('.primary_panel .body div[data-name="' + controller + '"] .value_wrap', :text => I18n.t(permission_value, :scope => 'admin.global'))
    end

    # edit should contain two roles
    visit edit_admin_role_path(new_role)
    within("form.edit_resource") do
      page.should have_select('Default controller', :selected => I18n.t(new_role.default_controller, :scope => 'admin.menu_items'))
      Releaf.available_admin_controllers.each do |controller|
        if controller == "admin/books"
          page.should have_checked_field(I18n.t(controller, :scope => 'admin.menu_items'))
        else
          page.should have_unchecked_field(I18n.t(controller, :scope => 'admin.menu_items'))
        end
      end
    end

    # index should contain two roles
    visit admin_roles_path
    page.should have_css('.primary_panel .body .releaf_table .tbody .row', :count => 2)
    page.should have_css('.primary_panel .body .releaf_table .tbody .row[data-id="' + new_role.id.to_s  + '"] a:last', :text => I18n.t(new_role.default_controller, :scope => 'admin.menu_items'))

  end
end
