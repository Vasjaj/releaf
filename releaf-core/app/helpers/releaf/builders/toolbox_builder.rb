class Releaf::Builders::ToolboxBuilder
  include Releaf::Builders::Base
  include Releaf::Builders::Template
  include Releaf::Builders::ResourceToolbox

  def items
    list = []
    list << destroy_confirmation_link if feature_available? :destroy
    list
  end

  def destroy_confirmation_link
    button(t('Delete', scope: 'admin.global'), "trash-o lg", class: %w(ajaxbox danger),
           href: destroy_confirmation_url, data: {modal: true})
  end

  def destroy_confirmation_url
     url_for(action: :confirm_destroy, id: resource.id, index_url: index_url)
  end
end
