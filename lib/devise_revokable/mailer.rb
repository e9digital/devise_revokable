module DeviseRevokable
  module Mailer
    
    # Deliver an invitation email
    def revocation_instructions(resource)
      setup_mail(resource, :revocation_instructions)
    end
    
    def revocation_confirmation(resource)
      setup_mail(resource, :revocation_confirmation)
    end
  end
end
