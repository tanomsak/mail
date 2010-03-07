# encoding: utf-8
module Mail # :doc:

  require 'date'

  require 'active_support'
  require 'active_support/core_ext/hash/indifferent_access'
  require 'active_support/core_ext/object/blank'

  require 'uri'
  require 'net/smtp'
  require 'mime/types'

  if RUBY_VERSION <= '1.8.6'
    begin
      require 'tlsmail'
    rescue LoadError
      raise "You need to install tlsmail if you are using ruby <= 1.8.6"
    end
  end

  if RUBY_VERSION >= "1.9.1"
    require 'mail/version_specific/ruby_1_9'
    RubyVer = Mail::Ruby19
  else
    require 'mail/version_specific/ruby_1_8'
    RubyVer = Mail::Ruby18
  end

  require 'mail/version'

  require 'mail/core_extensions/nil'
  require 'mail/core_extensions/string'

  require 'mail/patterns'
  require 'mail/utilities'
  require 'mail/configuration'
  require 'mail/network/delivery_methods/smtp'
  require 'mail/network/delivery_methods/file_delivery'
  require 'mail/network/delivery_methods/sendmail'
  require 'mail/network/delivery_methods/test_mailer'
  require 'mail/network/retriever_methods/pop3'
  require 'mail/network/retriever_methods/imap'

  require 'mail/message'
  require 'mail/part'
  require 'mail/header'
  require 'mail/parts_list'
  require 'mail/attachments_list'
  require 'mail/body'
  require 'mail/field'
  require 'mail/field_list'

  # Load in all common header fields modules
  require 'mail/fields/common/address_container'
  require 'mail/fields/common/common_address'
  require 'mail/fields/common/common_date'
  require 'mail/fields/common/common_field'
  require 'mail/fields/common/common_message_id'
  require 'mail/fields/common/parameter_hash'

  require 'mail/fields/structured_field'
  require 'mail/fields/unstructured_field'
  require 'mail/envelope'

  require 'mail/vendor/treetop'
  parsers = %w[ rfc2822_obsolete rfc2822 address_lists phrase_lists
                date_time received message_ids envelope_from rfc2045 
                mime_version content_type content_disposition
                content_transfer_encoding content_location ]
  parsers.each do |parser|
    begin
      # Try requiring the pre-compiled ruby version first
      require 'treetop/runtime'
      require "mail/parsers/#{parser}"
    rescue LoadError
      # Otherwise, get treetop to compile and load it
      require 'treetop/runtime'
      require 'treetop/compiler'
      Treetop.load("mail/parsers/#{parser}")
    end
  end

  # Load in all header field elements
  elems = Dir.glob(File.join(File.dirname(__FILE__), 'mail', 'elements', '*.rb'))
  elems.each do |elem|
    require "mail/elements/#{File.basename(elem, '.rb')}"
  end
  
  # Load in all header fields
  fields = Dir.glob(File.join(File.dirname(__FILE__), 'mail', 'fields', '*.rb'))
  fields.each do |field|
    require "mail/fields/#{File.basename(field, '.rb')}"
  end
  
  # Load in all transfer encodings
  elems = Dir.glob(File.join(File.dirname(__FILE__), 'mail', 'encodings', '*.rb'))
  elems.each do |elem|
    require "mail/encodings/#{File.basename(elem, '.rb')}"
  end
  
  # Finally... require all the Mail.methods
  require File.join('mail', 'mail')

end
