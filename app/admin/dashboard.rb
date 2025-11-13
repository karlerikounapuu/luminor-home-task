# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Total Count
    panel "Total Configuration Items" do
      div class: "text-center py-8" do
        h2 ConfigurationItem.count.to_s, class: "text-5xl font-bold text-indigo-600 dark:text-indigo-500"
        para "Total Configuration Items", class: "mt-2 text-gray-600 dark:text-gray-400"
      end
    end

    # Count by Type and Status
    div class: "grid grid-cols-1 md:grid-cols-2 gap-4 mt-6" do
      div do
        panel "Configuration Items by Type" do
          if ConfigurationItem.any?
            type_counts = ItemType.left_joins(:configuration_items)
                                   .group("item_types.id", "item_types.name")
                                   .select("item_types.name", "COUNT(configuration_items.id) as count")
                                   .order("count DESC, item_types.name")

            table_for type_counts do
              column("Type") { |type| type.name }
              column("Count") { |type| type.count }
            end
          else
            para "No configuration items yet. Maybe add some?", class: "text-center py-4 text-gray-600"
          end
        end
      end

      div do
        panel "Configuration Items by Status" do
          if ConfigurationItem.any?
            status_counts = ItemStatus.left_joins(:configuration_items)
                                       .group("item_statuses.id", "item_statuses.name")
                                       .select("item_statuses.name", "COUNT(configuration_items.id) as count")
                                       .order("count DESC, item_statuses.name")

            table_for status_counts do
              column("Status") { |status| status_tag status.name }
              column("Count") { |status| status.count }
            end
          else
            para "No configuration items yet. Maybe add some?", class: "text-center py-4 text-gray-600"
          end
        end
      end
    end
  end
end
