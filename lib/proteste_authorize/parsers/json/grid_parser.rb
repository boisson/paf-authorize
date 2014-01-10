module ProtesteAuthorize
  module Parsers
    module Json
      class GridParser
        def initialize(json_parsered, allowed_actions)
          @json_parsered    = json_parsered
          @allowed_actions  = allowed_actions
          # puts @allowed_actions.inspect
        end

        def parse
          @json_parsered['aaData'].each do |row|
            output_td = []
            

            row[1]            = parse_td(row[1], true)
            row[row.size - 1] = parse_td(row[row.size - 1])
          end
          @json_parsered.to_json
        end

        def parse_td(td, keep_text = false)
          td = Nokogiri::HTML::DocumentFragment.parse(td)
          td.css('a').each do |link|
            unless render_link?(link)
              unless keep_text
                link.remove
              else
                link.replace link.content
              end
            end
          end
          td.to_html
        end

        def render_link?(link)
          # return true
          if self.link_show?(link)
            return @allowed_actions.include?("show")
          elsif self.link_edit?(link)
            return @allowed_actions.include?("edit")
          elsif self.link_destroy?(link)
            return @allowed_actions.include?("destroy")
          end
          true
        end

        def link_show?(link)
          link_parts = link['href'].split('/').reject{|t| t.blank? }
          link['data-method'].nil? && link['data-remote'] && link_parts.size == 2
        end

        def link_edit?(link)
          link_parts = link['href'].split('/').reject{|t| t.blank? }
          link['data-method'].nil? && link['data-remote'] && link_parts.size == 3 && link_parts.last == 'edit'
        end

        def link_versions?(link)
          link_parts = link['href'].split('/').reject{|t| t.blank? }
          link['data-method'].nil? && link['data-remote'] && link_parts.size == 3 && link_parts.last == 'edit?tab_versions=true'
        end

        def link_destroy?(link)
          link_parts = link['href'].split('/').reject{|t| t.blank? }
          link['data-method'] == 'delete' && link_parts.size == 2
        end
      end

      def self.parse(response, allowed_actions)
        json_parsered = JSON.parse(response.body)
        # puts "requiscao json:\n\n"
        # puts json_parsered.inspect
        # puts "-------------------------------\n\n\n\n\n"
        if self.grid?(json_parsered)
          grid_parser   = GridParser.new(json_parsered, allowed_actions)
          response.body = grid_parser.parse
          response
        else
          response
        end
      end

      def self.grid?(json_parsered)
        json_parsered.has_key?('iTotalRecords')
      end
    end
  end
end