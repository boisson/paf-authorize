require 'nokogiri'

module ProtesteAuthorize
  class Security

    def self.can?(permissions, path)
      return true if permissions.has_key?('full_access') && permissions['full_access']
      ProtesteAuthorize::Security.controller_permission?(permissions, path) && ProtesteAuthorize::Security.action_permission?(permissions, path)
    end

    def self.controller_permission?(permissions, path)
      permissions[path[:controller].to_s]
    end

    def self.action_permission?(permissions, path)
      permissions[path[:controller].to_s]['actions'].include?(path[:action].to_s) rescue false
    end

    module Html
      def self.parse_and_apply_permissions(response)
        return response
        # html += '123...'
        # document = Nokogiri::HTML::DocumentFragment.parse(body_response)
        # html = document.to_html
        # require 'pry'
        # binding.pry
        # puts "------------------"
        # puts body_response
        if self.html_response?(response)
          response = self.parse_html_response(response)
        else
          response = self.parse_json_response(response)
        end



        response
      end


      def self.html_response?(response)
        response.class.method_defined?(:header) && response.header['Content-Type'].include?('text/html')
      end

      def self.parse_json_response(json_response)
        
        # require 'json'
        # json_parsered = JSON.parse(json_response.first)
        # puts "-----------------------"
        # puts json_parsered.inspect
        # require 'pry'
        # binding.pry

        # puts "--------------"
        # puts json_response.class.inspect
        if json_response.is_a?(ActionDispatch::Response)
          # puts 'affff'
          json_response = self.parse_grid_response(json_response)
        end
        json_response
      end


      def self.parse_grid_response(json_response)
        
        json_parsered = JSON.parse(json_response.body)
        require 'pry'
        binding.pry
        if json_parsered.has_key?('iTotalRecords')
          json_parsered['aaData'].each do |row|
            last_td = Nokogiri::HTML::DocumentFragment.parse(row.last)
            last_td.css('a').each do |link|
              puts link.inspect
            end
          end
        end
        json_response
      end

      def self.parse_html_response(html_response)
        html_response
      end
    end
  end
end