module Devise
  module Models
    module Revokable
      extend ActiveSupport::Concern

      included do
        after_create :send_revocation_instructions
      end

      def revoke!
        unless_revoked do
          self.revocation_token = nil
          self.revoked_at = Time.now.utc

          # NOTE use this yield to perform any reset necessary on the
          #      account, e.g. reset password, change username, delete content posted
          yield if block_given?

          send_revocation_confirmation

          save(:validate => false)
        end
      end

      def revoked?
        !!revoked_at
      end

      def active?
        super && !revoked?
      end

      def inactive_message
        revoked? ? :revoked : super
      end

      protected

        def send_revocation_instructions
          unless_revoked do
            generate_revocation_token! if self.revocation_token.nil?
            DeviseRevokable.send_mail!(:revocation_instructions, self)
          end
        end

        def send_revocation_confirmation
          DeviseRevokable.send_mail!(:revocation_confirmation, self)
        end

        def unless_revoked
          unless revoked?
            yield
          else
            self.errors.add(:email, :already_revoked)
          end
        end
       
        def generate_revocation_token!
          generate_revocation_token && save(:validate => false)
        end

        def generate_revocation_token
          self.revoked_at = nil
          self.revocation_token = self.class.revocation_token
        end

      module ClassMethods
        def send_revocation_instructions(attributes = {})
          revokable = find_or_initialize_with_error_by(:email, attributes[:email], :not_found)
          revokable.send(:send_revocation_instructions) if revokable.persisted?
          revokable
        end

        def revoke_by_token(token)
          revokable = find_or_initialize_with_error_by(:revocation_token, token, :revocation_token_invalid)
          revokable.revoke! if revokable.persisted?
          revokable
        end

        def revocation_token
          generate_token(:revocation_token)
        end
      end
    end
  end
end
