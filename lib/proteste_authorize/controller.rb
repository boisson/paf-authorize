require 'active_support'
require File.expand_path(File.join(File.dirname(__FILE__), 'permission_store'))

module ProtesteAuthorize
  module Controller

    extend ActiveSupport::Concern

    included do
      before_filter :can_access?
      helper_method :can?, :cant?, :controller_permissions, :proteste_permissions
    end

    def can_access?
      if current_user && !can?
        respond_to do |format|
          format.html  {
            redirect_to unauthorized_path
          }
          format.js { render file: 'proteste_authorize/unauthorized.js.erb'}
          format.json {
            render :json => { 'error' => 'Access Denied' }.to_json
          }
        end
      end
    end

    def proteste_permissions
      ProtesteAuthorize::PermissionStore.load_user_permissions(view_context, APP_ID)
      # ProtesteAuthorize::Consumers.permissions(APP_ID, current_user.login)
    end

    def controller_permissions
      proteste_permissions[self.controller_name]['actions']
    end


    def can?(paths = {})
      if paths.is_a?(Array)
        paths.each do |p|
          path = {action: p.to_sym, controller: self.controller_name.to_sym}
          return true if ProtesteAuthorize::Security.can?(proteste_permissions, path)
        end
      else
        path = paths
        path = {action: path} if path.is_a?(Symbol)
        path = {action: self.action_name.to_sym, controller: self.controller_name.to_sym}.merge(path)
        return ProtesteAuthorize::Security.can?(proteste_permissions, path)
      end
      false
    end

    def cant?(path = {})
      can?(path) == false
    end
  end
end