[![coverage](https://git.octree.ch/decidim/vocacity/tasks/badges/main/coverage.svg?job=coverage-024)](https://github.com/octree-gva/voca-tasks)

[![release](https://git.octree.ch/decidim/vocacity/tasks/badges/main/release.svg)](https://github.com/octree-gva/voca-tasks)

# Voca

Create&Manage Decidim instances on-the-fly, deploy all its ecosystem.
Voca focuses on Decidim, released on [APGL-3 open-source license](LICENSE.md) and all the ecosystem around the platform. As _Decidim is not a tool, but a framework for digital democratic participation, many tools gravitates around Decidim._

\*Our ambition is to create with Voca **an open-source SaaS service from Decidim & its ecosystem.\***

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
The client is generated with `bundle exec rake update_voca_proto`, and
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
bundle && bundle exec rake test_app
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
