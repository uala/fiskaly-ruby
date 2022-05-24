# FiskalyRuby
FiskalyRuby is a gem developed by UALA/Treatwell SaaS (cash) team.
It provides a collection of commands that will help you communicate with Fiskaly Api (https://developer.fiskaly.com/api).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fiskaly-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fiskaly-ruby

you can find the official in depths documentation here: https://rubydoc.info/github/uala/fiskaly-ruby/master

## Usage

### Management API

#### Authenticate the management api

https://developer.fiskaly.com/api/management/v0/#operation/authenticate

```ruby
FiskalyRuby.management_authenticate(
  api_key: 'fiskaly_api_key',
  api_secret: 'fiskaly_api_secret'
)
```

#### Create a main organization:

https://developer.fiskaly.com/api/management/v0/#operation/createOrganization

```ruby
FiskalyRuby.management_organizations_create(
  token: 'access_token',
  payload: {
    name: 'main_shop_name',
    address_line1: 'main_shop_address',
    zip: 'main_shop_zip',
    town: 'main_shop_town',
    state: 'main_shop_states',
    country_code: 'DEU', # Check fiskaly api to know more about these codes
    tax_number: 'main_shop_tax_number'
  }
)
```

#### Create a managed organization:

https://developer.fiskaly.com/api/management/v0/#operation/createOrganization

```ruby
FiskalyRuby.management_organizations_create(
  token: 'access_token',
  payload: {
    name: 'shop_name',
    address_line1: 'shop_address',
    zip: 'shop_zip',
    town: 'shop_town',
    state: 'shop_states',
    country_code: 'DEU', # Check fiskaly api to know more about these codes
    tax_number: 'shop_tax_number',
    managed_by_organization_id: 'main_organization_id',
  }
)
```

#### Retrieve organization info (eather managed or main):

https://developer.fiskaly.com/api/management/organization/v0/#operation/retrieveOrganization

```ruby
FiskalyRuby.management_organizations_retrieve(
  token: 'access_token',
  organization_id: 'organization_id'
)
```

#### List organization apy keys (eather managed or main):

https://developer.fiskaly.com/api/management/v0/#operation/listApiKeys

```ruby
FiskalyRuby.management_organizations_api_keys_list(
  token: 'access_token',
  organization_id: 'organization_id',
  query: { status: 'enabled' } }
)
```

#### Create organization apy keys (eather managed or main):

https://developer.fiskaly.com/api/management/v0/#operation/createApiKey

```ruby
FiskalyRuby.management_organizations_api_keys_create(
  status: :enabled,
  name: "shop-#{shop.id}"
)
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fiskaly-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fiskaly-ruby/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FiskalyRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fiskaly-ruby/blob/master/CODE_OF_CONDUCT.md).
