module ProtesteAuthorize
  module Parsers
    module Html
      class GridParser
        def initialize(document, allowed_actions)
          @document         = document
          @allowed_actions  = allowed_actions
        end

        def parse
          @document.css('#crud-tab li a[href="#tab-new"]').remove unless @allowed_actions.include?("new")
          @document.css('#batch_destroy_link').remove unless @allowed_actions.include?("destroy")
          crud_datatable = @document.at_css('.crud_datatable')
          crud_datatable.set_attribute('data-permissions',@allowed_actions.join(',')) if crud_datatable
          @document.to_html
        end

      end

      def self.parse(response, allowed_actions)
        document = Nokogiri::HTML(response.body)
        if self.grid?(document)
          grid_parser = GridParser.new(document, allowed_actions)
          response.body = grid_parser.parse
        end

        response
      end

      def self.grid?(document)
        document.at_css('#crud-tab li a[href="#tab-new"]')
      end
    end
  end
end