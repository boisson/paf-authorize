require 'nokogiri'
# require 'parsers/html/html_parser'
# require 'parsers/json/grid_parser'
require File.expand_path(File.join(File.dirname(__FILE__), 'parsers','html', 'html_parser'))
require File.expand_path(File.join(File.dirname(__FILE__), 'parsers','json', 'grid_parser'))

module ProtesteAuthorize
  class RequestProcessor
    def initialize(status, headers, response)
      @status   = status
      @headers  = headers
      @response = response
    end

    def valid?
      @response.is_a?(ActionDispatch::Response) && (self.html? || self.json? || self.rjs?)
    end

    def invalid?
      self.valid? == false
    end
    

    def process
      return self.process_without_parsing if self.invalid?
      return self.process_without_parsing if self.root_access?

      if self.html?
        @response = ProtesteAuthorize::Parsers::Html.parse(@response, self.allowed_actions)
      elsif self.json?
        @response = ProtesteAuthorize::Parsers::Json.parse(@response, self.allowed_actions)
      end

      [@status, @headers, @response]
    end

    def allowed_actions
      return [] unless proteste_permissions
      controller            = @response.request.env['action_dispatch.request.path_parameters'][:controller]
      proteste_permissions[controller] ? proteste_permissions[controller]['actions'] : []
    end


    protected
    def root_access?
      proteste_permissions && !proteste_permissions.is_a?(Array) && proteste_permissions.has_key?('full_access') && proteste_permissions['full_access']
    end

    def proteste_permissions
      if current_user_id
        # puts "-------------"
        # puts current_user_login
        Rails.cache.delete("proteste_permissions_#{current_user_id}") unless in_cache?

        Rails.cache.fetch("proteste_permissions_#{current_user_id}", expires_in: 2.hours) do
          ProtesteAuthorize::Consumers.permissions(APP_ID, current_user_login)
        end
      else
        {}
      end
    end

    def in_cache?
      @response.request.env['rack.session']['permissions_on_cache']
    end

    def current_user_id
      if warden_user
        warden_user['id']
      elsif session_user
        session_user['uid']
      end
    rescue
      false
    end

    def current_user_login
      if warden_user
        warden_user['login']
      elsif session_user
        session_user['info']['login']
      end
    rescue
      false
    end

    def warden_user
      @response.request.env['warden'].user if @response.request.env['warden']
    end

    def session_user
      @response.request.env['rack.session']['user_id'] if @response.request.env['rack.session'].has_key?('user_id')
    end

    def process_without_parsing
      [@status, @headers, @response]
    end

    def html?
      @response.header['Content-Type'].include?('text/html')
    end

    def json?
      @response.header['Content-Type'].include?('application/json')
    end

    def rjs?
      @response.header['Content-Type'].include?('text/javascript; charset=utf-8')
      
    end
  end
end