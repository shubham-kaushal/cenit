require 'builder'
require 'prawn-rails'

module Setup
  module Transformation
    #ActionView::Template.register_template_handler(:haml, Haml::Plugin)
    class ActionViewTransform < Setup::Transformation::AbstractTransform

      class << self

        def run(options = {})
          transformation = options[:transformation]
          object = options[:object]
          split_style = options[:style].split('.') if options[:style].present?

          format = options[:format] ||= split_style[0].to_sym if split_style[0].present?
          handler = options[:handler] ||= split_style[1].to_sym if split_style[1].present?

          if handler.present? && metaclass.instance_methods.include?(met = "run_#{handler}".to_sym)
            send(met, options)
          else
            ActionView::Base.new.try :render, inline: transformation, formats: format, type: handler, handlers: handler, locals: options
          end
        end

        def run_rabl(options = {})
          Rabl::Renderer.new(options[:transformation], nil, {format: options[:format], locals: options}).render
        end

        def run_haml(options = {})
          Haml::Engine.new(options[:transformation]).render(Object.new, options)
        end

        # def run_prawn(options = {})
        #   result = PrawnRails::Engine.try(:new).try :render, inline: options[:transformation], format:  options[:format],  locals: options
        #   result
        # end

        def types
          [:Export]
        end

      end
    end
  end
end