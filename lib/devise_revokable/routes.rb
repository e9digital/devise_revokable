module ActionDispatch::Routing
  class Mapper
    protected
      def devise_revocation(mapping, controllers)
        resource :revocation, :only => :update, :path => mapping.path_names[:revocation], :controller => controllers[:revocations] do
          get :edit, :path => mapping.path_names[:confirm], :as => :confirm
        end
      end
  end
end
