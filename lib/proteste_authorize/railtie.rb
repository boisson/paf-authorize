require 'rails/railtie'
require 'proteste_authorize/consumers'
require 'proteste_authorize/controller'
require 'proteste_authorize/view_helpers'

module ProtesteAuthorize
  class Railtie < Rails::Railtie
    initializer "proteste_authorize.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include ProtesteAuthorize::Controller # ActiveSupport::Concern
      end
    end

    initializer "proteste_authorize.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end