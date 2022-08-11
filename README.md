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

# Decidim::Voca

This Gem allows configuring a Decidim instance with gRPC. This is a domain-specific gem, which is useful only if you host your own Voca.

## Update gRPC `.proto`

To get the last gRPC `.proto`, execute the following command:

```ruby
bundle exec rake update_voca_proto

#   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
#                                  Dload  Upload   Total   Spent    Left  Speed
#   0     0    0     0    0     0      0      0 --:--:-- -100  1883  100  1883    0     0   7354      0
# ✅ /lib/decidim/decidim-voca/grpc udpated
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-voca"
```

And then execute:

```sh
bundle install
```

## Usage: Tasks

- **`rails voca:backup`** execute a backup of your db and public/uploads folder
- **`rails voca:webhook payload="<JSON_STRING>" name="<EVENT_NAME>" now="false"`** call the strapi with a payload
  - `payload`
    > a JSON string to send to the voca service
  - `name`
    > an event name, like `decidim.install`
  - `now`
    > _(optional)_ if the webhook should be send now instead of enqueued.
    > Default: `false`
- **`rails voca:command name="<COMMAND_NAME>" vars="<JSON INPUTS>"`** enqueue an active job to execute a rake task
  - `name`
    > the name of voca:\* command.
    > Default: `backup`
  - `vars`
    > JSON string of the args to pass.
    > Example: "{\"foo\": \"bar\", \"now\": \"true\"}" will pass `foo="bar" now="true"` to the command

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
