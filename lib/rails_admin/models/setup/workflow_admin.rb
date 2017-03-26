module RailsAdmin
  module Models
    module Setup
      module WorkflowAdmin
        extend ActiveSupport::Concern

        included do
          rails_admin do
            navigation_label 'Workflows'
            weight 500
            object_label_method { :name }

            edit do
              field :name do
                required true
              end
              field :description
              field :valid_from do
                required true
              end
              field :valid_to do
                required true
              end
              field :status, :enum do
                required true
                visible do
                  !bindings[:object].new_record?
                end
              end
              field :activities do
                required true
                visible do
                  !bindings[:object].new_record?
                end
              end
            end

            list do
              field :name
              field :valid_from
              field :valid_to
              field :updated_at
              field :status
            end

            show do
              field :name
              field :valid_from
              field :valid_to
              field :updated_at
              field :status
              field :diagram do
                formatted_value do
                  bindings[:view].render partial: 'rails_admin/workflow/diagram', :locals => {workflow: bindings[:object]}
                end
              end
            end

          end
        end

      end
    end
  end
end
