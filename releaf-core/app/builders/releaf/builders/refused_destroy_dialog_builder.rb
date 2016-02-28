class Releaf::Builders::RefusedDestroyDialogBuilder
  include Releaf::Builders::ResourceDialog

  def section_body
    message = "Deletion of %{resource} restricted due to existing relations:"
    tag(:div, class: "body") do
      [
        icon("ban"),
        tag(:div, t(message, default: message, resource: resource_title(resource)), class: "description"),
        restricted_relations
      ]
    end
  end

  def restricted_relations
    tag(:ul, class: "restricted-relations") do
      template_variable("restricted_relations").collect do|key, relation|
        tag(:li) do
          restricted_relation(relation, key)
        end
      end
    end
  end

  def relation_description(relation, key)
      (
        unless relation[:controller].nil?
          I18n.t(relation[:controller], scope: 'admin.controllers')
        else
          I18n.t(key, scope: 'admin.controllers')
        end
      ) << " (#{relation[:objects].count})"
  end

  def relation_objects(relation)
    tag(:ul, class: "relations") do
      relation[:objects][0..2].collect do |item|
          relation_objects_item(item, relation)
      end + [(tag(:li, "...") if relation[:objects].count > 3)]
    end
  end

  def relation_objects_item(item, relation)
    tag(:li) do
      unless relation[:controller].nil?
        link_to(resource_title(item), controller: relation[:controller], action: "edit", id: item)
      else
        resource_title(item)
      end
    end
  end

  def restricted_relation(relation, key)
    [
      relation_description(relation, key),
      relation_objects(relation)
    ]
  end

  def footer_primary_tools
    [
      button(t("Ok"), "check", href: index_url, data: {type: 'cancel'})
    ]
  end

  def section_header_text
    t("Deletion refused")
  end
end
