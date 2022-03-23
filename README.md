# Decidim::VocacityGemTasks

vocacity_gem_tasks.

## Usage

VocacityGemTasks will be available as a Component for a Participatory
Space.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-vocacity_gem_tasks"
```

And then execute:

```sh
bundle install
```
## Tasks

* **`rails vocacity:backup`** execute a backup of your db and public/uploads folder
* **`rails vocacity:webhook payload="<JSON_STRING>" name="<EVENT_NAME>" now="false"`**
    * `payload`
        > a JSON string to send to the vocacity service
    * `name`
        > an event name, like `decidim.install`
    * `now` 
        > _(optional)_ if the webhook should be send now instead of enqueued. 
        > Default: `false`



## Development
We suppose you have docker installed in your environment.

```sh
docker-compose up -d
docker-compose run --rm app bash -c "cd $RAILS_ROOT && rails db:migrate"
```

Your developpement app with the gem is ready on `http://localhost:3000`

### Run tests

`test_app` will create a `spec/dummy` app, and will run a localhost postgres container.
This command have to be done before executing tests.
```sh
bundle exec rake test_app
```

Once this command pass, execute:
```sh
bundle exec rspec spec
```
to run the unit tests.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
