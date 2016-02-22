# -*- encoding : utf-8 -*-
require 'pacto/formats/legacy/contract'

module Pacto
  module Formats
    module Legacy
      # Builds {Pacto::Formats::Legacy::Contract} instances from Pacto's legacy Contract format.
      class ContractFactory
        attr_reader :schema

        def initialize(options = {})
          @schema = options[:schema] || MetaSchema.new
        end

        def build_from_file(contract_path, host)
          contract_definition = File.read(contract_path)
          definition = JSON.parse(contract_definition)
          schema.validate definition
          definition['request'].merge!('host' => host)
          body_to_schema(definition, 'request', contract_path)
          body_to_schema(definition, 'response', contract_path)
          method_to_http_method(definition, contract_path)
          request = RequestClause.new(definition['request'])
          response = ResponseClause.new(definition['response'])
          Contract.new(request: request, response: response, file: contract_path, name: definition['name'], examples: definition['examples'])
        end

        def files_for(contracts_dir)
          full_path = Pathname.new(contracts_dir).realpath

          if  full_path.directory?
            all_json_files = "#{full_path}/**/*{.json,.json.erb}"
            Dir.glob(all_json_files).map do |f|
              Pathname.new(f)
            end
          else
            [full_path]
          end
        end

        private

        def body_to_schema(definition, section, file)
          schema = definition[section].delete 'body'
          return nil unless schema

          Pacto::UI.deprecation "Contract format deprecation: #{section}:body will be moved to #{section}:schema (#{file})"
          definition[section]['schema'] = schema
        end

        def method_to_http_method(definition, file)
          method = definition['request'].delete 'method'
          return nil unless method

          Pacto::UI.deprecation "Contract format deprecation: request:method will be moved to request:http_method (#{file})"
          definition['request']['http_method'] = method
        end

        Pacto::ContractFactory.add_factory(:legacy, ContractFactory.new)
      end
    end
  end
end
