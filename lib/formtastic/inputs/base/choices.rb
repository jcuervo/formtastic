module Formtastic
  module Inputs
    module Base
      module Choices
        
        def choices_wrapping(&block)
          template.content_tag(:fieldset, 
            template.capture(&block),
            choices_wrapping_html_options
          )
        end

        def choices_wrapping_html_options
          {}
        end

        def choices_group_wrapping(&block)
          template.content_tag(:ol, 
            template.capture(&block),
            choices_group_wrapping_html_options
          )
        end

        def choices_group_wrapping_html_options
          {}
        end

        def choice_wrapping(html_options, &block)
          template.content_tag(:li, 
            template.capture(&block),
            html_options
          )
        end

        def choice_wrapping_html_options(choice)
          { :class => value_as_class? ? "#{sanitized_method_name.singularize}_#{choice_html_safe_value(choice)}" : '' }
        end

        def choice_html(choice)        
          raise "choice_html() needs to be implemented when including Formtastic::Inputs::Base::Choices"
        end

        def choice_label(choice)
          choice.is_a?(Array) ? choice.first : choice
        end

        def choice_value(choice)
          choice.is_a?(Array) ? choice.last : choice
        end

        def choice_html_safe_value(choice)
          choice_value(choice).to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase
        end

        def choice_input_dom_id(choice)
          [
            builder.custom_namespace,
            sanitized_object_name,
            association_primary_key || method,
            choice_html_safe_value(choice)
          ].compact.reject { |i| i.blank? }.join("_")
        end
        
        def value_as_class?
          options[:value_as_class]
        end

        def legend_html
          if render_label?
            template.content_tag(:legend,
              template.content_tag(:label, label_text),
              label_html_options.merge(:class => "label")
            )
          else
            "".html_safe
          end
        end
        
        # Override to remove the for attribute since this isn't associated with any element, as it's
        # nested inside the legend.
        def label_html_options
          super.merge(:for => nil)
        end

      end
    end
  end
end