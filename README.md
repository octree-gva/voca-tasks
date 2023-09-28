[![coverage](https://git.octree.ch/decidim/vocacity/tasks/badges/main/coverage.svg?job=coverage-024)](https://github.com/octree-gva/voca-tasks)

[![release](https://git.octree.ch/decidim/vocacity/tasks/badges/main/release.svg)](https://github.com/octree-gva/voca-tasks)

# Voca

Create&Manage Decidim instances on-the-fly, deploy all its ecosystem.
Voca focuses on Decidim, released on [APGL-3 open-source license](LICENSE.md) and all the ecosystem around the platform. As _Decidim is not a tool, but a framework for digital democratic participation, many tools gravitates around Decidim._

# RPC private API for Decidim
This gem add internal functionalities to Decidim in order to be managed remotly. We do mostly: 

- Setup [gruf](https://github.com/bigcommerce/gruf) to run a gRPC server
- Implement the [decidim.proto](https://raw.githubusercontent.com/octree-gva/voca-system/main/backend/contrib/rpc-protos/decidim/decidim.proto) spec
- Add a middleware two dynamically set config data. 


## RPC
From the .proto file, two files are generated, lib/decidim/voca/rpc/decidim_pb.rb and lib/decidim/voca/rpc/decidim_services_pb.rb. These files describe the skeletton of the input and response we need to comply. 

In the controller `Decidim::Voca::DecidimServiceController`, we bind its method to these services and execute Commands for each methods. 
For example, a compile method is implemented this way: 

```
    ## Compile assets.
    def compile_assets
        `bundle exec rails assets:precompile`
        ::Google::Protobuf::Empty.new
    end
```

When the code to resolves a RPC methods take more than 2 lines, we do a Command to isolate the code in one class. This is the case for most of the code. You can find the in the [rpc directory](./app/rpc/decidim/voca/rpc).

### Casting
As RPC is a generic way to build APIs, we have to translate constants in appropriate string for the application. 

For example, `SETTINGS_REGISTER_MODE_OPTION::SETTINGS_REGISTER_MODE_REGISTER_AND_LOGIN` is actually just `enable` for the user_register_mode Decidim settings. To do so, 
we have an utility class `Decidim::Voca::Rpc::EnumCaster`.

## Middleware
We get inspiration on [this article](https://pawelurbanek.com/rails-dynamic-config) to setup a middleware that retrieve config values from redis and then inject it into the code. 

For every query, we do a small step of getting data from our Redis store, 
and inject the configuration object in Decidim. Like this:
```
 # ./lib/decidim/voca/middleware/dynamic_config_middleware.rb
    if config_data["currency_unit"].present?
        Decidim.currency_unit = config_data["currency_unit"]
    end
```

This is particularly usefull as it allows us to include Decidim configurations in our `decidim.proto` file, and set the redis value when needed. 

```
# ./app/commands/decidim/voca/organization/update_locale_command.rb
global_configuration = locale_settings.select do |key| 
    "#{key}" == "currency_unit" || "#{key}" == "timezone"
end.delete_if { |_k, v| v.blank? }
unless global_configuration.empty?
    redis_client = Redis.new(
        url: ENV.fetch("REDIS_CONFIG_URL", "redis://127.0.0.1:6379/2"),
    );
    global_configuration.each do |key, value|
        # Update the Redis hash values
        redis_client.hset("config", "#{key}", "#{value}")
    end
    # Close the Redis connection
    redis_client.quit  
end
```
## Repositories

| repo                                                     | info                                                                        | stable version |
| -------------------------------------------------------- | --------------------------------------------------------------------------- | -------------- |
| [voca-system](https://github.com/octree-gva/voca-system) | Install and manage decidim instances through a Dashboard                    | v0.1.0         |
| [voca-tasks](https://github.com/octree-gva/voca-tasks)   | Gem embedded in our Decidim image. Manipulate and manage decidim instances. | v0.1.0         |
| [voca-jps](https://github.com/octree-gva/voca-jps)       | Jelastic Manifest to deploy Decidim images                                  | v0.1.0         |
| [voca-docker](https://github.com/octree-gva/voca-docker) | Build Decidim docker images for Voca                                        | v0.1.0         |
| [voca-protos](https://github.com/octree-gva/voca-protos) | RPC prototypes for voca                                        | v0.1.0         |

# Decidim::Voca

This Gem allows configuring a Decidim instance with gRPC. This is a domain-specific gem, which is useful only if you host your own Voca system.

## Readings before starting

* [gruf, a RPC gem for rails](https://github.com/bigcommerce/gruf)
* [GRPC for ruby](https://grpc.io/docs/languages/ruby/)
* [proto3 Styleguide](https://developers.google.com/protocol-buffers/docs/style)

## Repository structure

### Generated client
The client is generated with `bundle exec rails update_voca_proto`, and
save the client and service in [`/lib/decidim/voca/rpc`](./lib/decidim/voca/rpc)

### RPC Decidim Service
The entry point for RPC Decidim Service is in [`/app/rpc/decidim/voca/decidim_service_controller.rb`](./app/rpc/decidim/voca/decidim_service_controller.rb).
This controller have a method per registered message, and will call some concerns in the `/app/rpc/decidim/voca/rpc` folder.

### Updating commands
We use Rectify::Command in `/app/commmands/decidim/voca` for all update-related command.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-voca"
```

And then execute:

```sh
bundle install
```

## Development

We suppose you have docker installed in your environment.

```sh
docker-compose up -d
docker-compose run --rm app bash -c "cd $RAILS_ROOT && rails db:migrate"
```

Your development app with the gem is ready on `http://localhost:3000`

### Run tests

`test_app` will create a `spec/dummy` app, and will run a local PostGres container.
This command has to be done before executing tests.

```sh
bundle && bundle exec rails test_app
```

Once this command pass, execute:

```sh
bundle exec rspec spec
```

to run the unit tests.

## Contributing

See [Contributing](CONTRIBUTING.md).

## License

See [License](LICENSE.md).
