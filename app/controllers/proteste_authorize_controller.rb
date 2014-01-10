class ProtesteAuthorizeController < ApplicationController
  skip_before_filter :can_access?
  skip_before_filter :login_required
  skip_before_filter :authenticate_user!
  skip_before_filter :check_user_status

  def unauthorized
  end
end