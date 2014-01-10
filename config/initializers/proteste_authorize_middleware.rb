require 'proteste_authorize/permission_handler'

Rails.application.config.middleware.use ProtesteAuthorize::PermissionHandler