module ActionDispatch::Routing
  class Mapper
    def paf_authorize
      match  "phoenix/unauthorized" => "proteste_authorize#unauthorized", :as => "unauthorized"
    end
  end
end