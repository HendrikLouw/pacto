-*- encoding : utf-8 -*-
Just require pacto to add it to your project.

```rb
require 'pacto'
```

Pacto will disable live connections, so you will get an error if
your code unexpectedly calls an service that was not stubbed.  If you
want to re-enable connections, run `WebMock.allow_net_connect!`

```rb
WebMock.allow_net_connect!
```

Pacto can be configured via a block:

```rb
Pacto.configure do |c|
```

Path for loading/storing contracts.

```rb
  c.contracts_path = 'contracts'
```

If the request matching should be strict (especially regarding HTTP Headers).

```rb
  c.strict_matchers = true
```

You can set the Ruby Logger used by Pacto.

```rb
  c.logger = Pacto::Logger::SimpleLogger.instance
```

(Deprecated) You can specify a callback for post-processing responses.  Note that only one hook
can be active, and specifying your own will disable ERB post-processing.

```rb
  c.register_hook do |_contracts, request, _response|
    puts "Received #{request}"
  end
```

Options to pass to the [json-schema-generator](https://github.com/maxlinc/json-schema-generator) while generating contracts.

```rb
  c.generator_options = { schema_version: 'draft3' }
end
```

You can also do inline configuration.  This example tells the json-schema-generator to store default values in the schema.

```rb
Pacto.configuration.generator_options = { defaults: true }
```

If you're using Pacto's rspec matchers you might want to configure a reset between each scenario

```rb
require 'pacto/rspec'
RSpec.configure do |c|
  c.after(:each)  { Pacto.clear! }
end
```

