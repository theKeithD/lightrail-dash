module Extensions #:nodoc:
  # Module to be included by every model that will have a username and password.
  #--
  # ...except for JiraIssueSummary.
  #++
  # Passwords are hashed with SHA256.
  # 
  # == Properties
  # - +username+ (String): Username
  # - +password+ (String): Password
  module Passworded
    extend ActiveSupport::Concern
    
    included do
      require "digest/sha2"
      
      property :username,   DataMapper::Property::String
      property :password,   DataMapper::Property::String
      
      attr_accessor :password_plaintext, :password_plaintext_confirmation
      
      validates_confirmation_of :password_plaintext, :if => :password_validation_required?
      validates_presence_of :password_plaintext, :if => :password_validation_required?
      
      before :save, :hash_password
    end
    
    # Methods used for password hashing and confirmation
    module InstanceMethods
      # Hash given password and check it against the hash stored in the database.
      def valid_password?(password_plaintext)
        self.password == Extensions::Passworded.hash_password(password_plaintext)
      end
      
      # Set +password+ to a hashed version of the password given by entry form if the password field is not blank.
      def hash_password
        if(!self.password_plaintext.blank?)
          self.password = Extensions::Passworded.hash_password(self.password_plaintext)
        end
      end
      
      # Check if the entry form requires password field.
      # Password validation is only required if this is a new Passworded item or if the user has entered something into the password field.
      def password_validation_required?
        self.new? ? true : !self.password_plaintext.blank?
      end
    end
    
    # Perform SHA256 hashing on a given password string.
    # Salt can be overridden.
    def self.hash_password(password_plaintext, salt = "5oeQ44GL44GX44GN5p2x5pa544Gu6KGACg") #:nodoc:
      Digest::SHA2.hexdigest("#{salt}-%*%-#{password_plaintext}")
    end
  end
end
