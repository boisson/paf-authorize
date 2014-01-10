module ProtesteAuthorize
  if defined?(Rails)
    require "proteste_authorize/engine"
    require "proteste_authorize/railtie"
  end
end

require "action_view"
require "proteste_authorize/security"
require "proteste_authorize/request_processor"
require 'proteste_authorize/rails/routes'