require 'rails/generators'
require 'active_support'
module ProtesteAuthorize
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install files for authorization"

      def add_route
        route("paf_authorize")
      end
    end
  end
end