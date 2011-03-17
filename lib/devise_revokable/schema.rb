module DeviseRevokable
  module Schema
    def revokable
      apply_devise_schema :revocation_token, String,  :limit => 60
      apply_devise_schema :revoked_at,       DateTime
    end
  end
end

Devise::Schema.send :include, DeviseRevokable::Schema
