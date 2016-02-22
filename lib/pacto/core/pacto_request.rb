# -*- encoding : utf-8 -*-
require 'hashie/mash'

module Pacto
  class PactoRequest
    # FIXME: Need case insensitive header lookup, but case-sensitive storage
    attr_accessor :headers, :body, :method, :uri, :dynamic_path

    include BodyParsing

    def initialize(data)
      mash = Hashie::Mash.new data
      @headers = mash.headers.nil? ? {} : mash.headers
      @body    = mash.body
      @method  = mash[:method]
      @uri     = mash.uri
      @dynamic_path = mash.dynamic_path
      normalize
    end

    def to_hash
      {
        method: method,
        uri: uri,
        headers: headers,
        body: body
      }
    end

    def to_s
      string = Pacto::UI.colorize_method(method)
      string << " #{relative_uri}"
      string << " with body (#{raw_body.bytesize} bytes)" if raw_body
      string
    end

    def relative_uri
      uri.to_s.tap do |s|
        s.slice!(uri.normalized_site)
      end
    end

    def normalize
      @method = @method.to_s.downcase.to_sym
      @uri = @uri.normalize if @uri
    end
  end
end
