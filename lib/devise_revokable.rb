require 'rails'
require 'devise'
require 'devise_revokable/routes'
require 'devise_revokable/schema'
require 'devise_revokable/mailer'
require 'devise_revokable/controllers/url_helpers'

module DeviseRevokable
  autoload :VERSION, 'devise_revokable/version'

  ##
  # Allow for another mailer besides Devise
  #
  mattr_accessor :mailer
  @@mailer = nil

  def self.send_mail!(method_name, resource)
    if @@mailer.respond_to?(:call)
      @@mailer.call(method_name, resource)
    else
      ::Devise.mailer.send(method_name, resource).deliver
    end
  end

  class Engine < ::Rails::Engine
    [:action_controller, :action_view].each do |klass|
      ActiveSupport.on_load(klass) { include DeviseRevokable::Controllers::UrlHelpers }
    end

    config.after_initialize do
      require 'devise/mailer'
      ::Devise::Mailer.send :include, DeviseRevokable::Mailer
    end
  end
end

Devise.add_module :revokable, :controller => :revocations, :model => 'devise_revokable/model', :route => :revocation
