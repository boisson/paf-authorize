module ProtesteAuthorize
  class PermissionStore
    delegate :current_user, :session, to: :@view

    def initialize(view, app_id)
      @view   = view
      @app_id = app_id
    end

    def valid?
      current_user? && app_id?
    end

    def invalid?
      !valid?
    end

    def permissions!
      return permissions if has_permissions?
      cache!
      @permissions = Rails.cache.fetch("proteste_permissions_#{current_user.id}", expires_in: 2.hours) do
        get_permissions
      end
    end

    def permissions
      @permissions
    end

    def self.load_user_permissions(view, app_id)
      permission = ProtesteAuthorize::PermissionStore.new(view, app_id)
      return nil if permission.invalid?

      permission.permissions!
    end

    protected

    def get_permissions
      ProtesteAuthorize::Consumers.permissions(app_id, user_login)
    end

    def has_permissions?
      in_cache? && !permissions.nil?
    end

    def user_login
      current_user.login
    end

    def app_id
      @app_id
    end

    def current_user?
      !current_user.nil?
    end

    def app_id?
      !@app_id.nil?
    end

    def in_cache?
      if session[:permissions_on_cache].nil?
        Rails.cache.delete("proteste_permissions_#{current_user.id}")
        false
      else
        true
      end
    end

    def cache!
      session[:permissions_on_cache] ||= true
    end

  end
end