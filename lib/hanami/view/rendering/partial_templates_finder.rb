require 'hanami/view/template'
require 'hanami/view/rendering/partial_file'

module Hanami
  module View
    module Rendering
      # Find partial templates in the file system
      #
      # @api private
      # @since 0.7.0
      #
      # @see View::Template
      class PartialTemplatesFinder
        # Search pattern for partial file names
        #
        # @api private
        # @since 0.7.0
        PARTIAL_PATTERN = '_*'.freeze

        # @api private
        # @since 0.7.0
        PARTIAL_PARTS_SEPARATOR = '.'.freeze

        # @api private
        # @since 0.7.0
        attr_reader :configuration

        # Initializes a new PartialTemplatesFinder
        #
        # @param configuration [Configuration] the configuration object
        #
        # @since 0.7.0
        # @api private
        def initialize(configuration)
          @configuration = configuration
        end

        # Find partials under the given path
        #
        # @return [Array] array of PartialFinder objects
        #
        # @since 0.7.0
        # @api private
        def find
          _find_partials(configuration.root).map do |template|
            partial_path, partial_base_name = Pathname(template).relative_path_from(configuration.root).split
            partial_base_parts              = partial_base_name.to_s.split(PARTIAL_PARTS_SEPARATOR)

            PartialFile.new(
              "#{partial_path}#{::File::SEPARATOR}#{partial_base_parts[0]}",
              partial_base_parts[1],
              View::Template.new(template, configuration.default_encoding)
            )
          end
        end

        private

        # Find partial template file paths
        #
        # @param path [String] the path under which we should search for partials
        #
        # @return [Array] an array of strings for each matching partial template file found
        #
        # @since 0.7.0
        # @api private
        def _find_partials(path)
          Dir.glob("#{ [path, TemplatesFinder::RECURSIVE, PARTIAL_PATTERN].join(::File::SEPARATOR) }.#{TemplatesFinder::FORMAT}.#{TemplatesFinder::ENGINES}")
        end
      end
    end
  end
end
