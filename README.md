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

#### Summary:

- [Management API usage](#management-api)

- [DSFinV-K API usage](#DSFinV-K-api)

- [KassenSichV API usage](#kassensichv-api)

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

### DSFinV-K API

#### Authenticate the DSFinV-K api

https://developer.fiskaly.com/api/dsfinvk/v1#operation/authenticate

```ruby
FiskalyRuby.dsfinvk_authenticate(
  api_key: 'fiskaly_api_key',
  api_secret: 'fiskaly_api_secret'
)
```

#### Create (upsert) cash register
https://developer.fiskaly.com/api/dsfinvk/v1#operation/upsertCashRegister

```ruby
FiskalyRuby.dsfinvk_cash_registers_upsert(
  token: 'access_token',
  client_id: 'fiskaly_client_id',
  payload: {
    cash_register_type: {
      type: 'MASTER',
      tss_id: 'fiskaly_tss_id'
    },
    brand: 'cash_register_brand',
    model: 'cash_register_model',
    software: {
      brand: 'brand'
    },
    base_currency_code: 'EUR' # check these code references in fiskaly api documentation
  }
)
```
#### Retrieve cash register

https://developer.fiskaly.com/api/dsfinvk/v1#operation/retrieveExport exports retrieve

```ruby
FiskalyRuby.dsfinvk_cash_registers_retrieve(
  token: 'access_token',
  client_id: 'client_id'
)
```


#### Create Cash Point Closing

https://developer.fiskaly.com/api/dsfinvk/v1#operation/insertCashPointClosing

```ruby
FiskalyRuby.dsfinvk_cash_point_closing_create(
  token: 'access_token',
  closing_id: 'closing_id',
  payload: {
    head: {
      first_transaction_export_id: "first_transaction_export_id",
      last_transaction_export_id: "last_transaction_export_id",
      export_creation_date: 81421343 # needs to be integer ex: Time.now.to_i
    },
    cash_statement: {
      business_cases: [
        {
          type: "EinzweckgutscheinKauf",
          amounts_per_vat_id: [
            {
              incl_vat: "40.00000",
              excl_vat: "32.40000",
              vat: "7.60000",
              vat_definition_export_id: 1
            },
          ]
        }
      ],
      payment: {
        full_amount: "40.00000",
        cash_amount: "40.00000",
        cash_amounts_by_currency: [
          {
            currency_code: "EUR",
            amount: "40.00000"
          }
        ],
        payment_types: [
          {
            type: "Bar",
            currency_code: "EUR",
            amount: "40.00000"
          }
        ]
      }
    },
    transactions: [
      {
        head: {
          type: "Beleg",
          storno: false,
          number: 9007199254740991,
          timestamp_start: 81421343 # needs to be integer ex: Time.now.to_i
          timestamp_end: 81421343 # needs to be integer ex: Time.now.to_i
          user: {
            name: "test",
            user_export_id: "1"
          },
          buyer: {
            name:  'customer name',
            type: "Kunde",
            buyer_export_id: '1'
          },
          tx_id: "00000000-0000-0000-0000-000000000000",
          transaction_export_id: "00000000-0000-0000-0000-000000000000",
          closing_client_id: "client_id"
        },
        data: {
          full_amount_incl_vat: "20.00000",
          payment_types: [
            {
              type: "Bar",
              currency_code: "EUR",
              amount: "20.00000"
            }
          ],
          amounts_per_vat_id: [
            {
              incl_vat: "20.00000",
              excl_vat: "16.20000",
              vat: "3.80000",
              vat_definition_export_id: 1
            }
          ],
          lines: [
            {
              business_case: {
                amounts_per_vat_id: [
                  {
                    excl_vat: "30.00000",
                    incl_vat: "30.00000",
                    vat: "0.00000",
                    vat_definition_export_id: 5
                  }
                ],
                type: "EinzweckgutscheinKauf"
              },
              item: {
                number: 1,
                price_per_unit: "30.00000",
                quantity: 1
              },
              lineitem_export_id: 1,
              storno: false,
              text: nil
            }
          ]
        },
        security: {
          tss_tx_id: "00000000-0000-0000-0000-000000000000"
        }
      },
      {
        head: {
          type: "Beleg",
          storno: false,
          number: 9007199254740991,
          timestamp_start: 81421343 # needs to be integer ex: Time.now.to_i
          timestamp_end: 81421343 # needs to be integer ex: Time.now.to_i
          user: {
            name: "testtesttesttesttesttesttesttesttesttesttestte...",
            user_export_id: "1"
          },
          buyer: {
            name:  'customer name 2',
            type: "Kunde",
            buyer_export_id: '2'
          },
          tx_id: "00000000-0000-0000-0000-000000000000",
          transaction_export_id: "00000000-0000-0000-0000-000000000000",
          closing_client_id: "client_id"
        },
        data: {
          full_amount_incl_vat: "20.00000",
          payment_types: [
            {
              type: "Bar",
              currency_code: "EUR",
              amount: "20.00000"
            }
          ],
          amounts_per_vat_id: [
            {
              incl_vat: "20.00000",
              excl_vat: "16.20000",
              vat: "3.80000",
              vat_definition_export_id: 1
            }
          ],
          lines: [
            {
              business_case: {
                amounts_per_vat_id: [
                  {
                    excl_vat: "30.00000",
                    incl_vat: "30.00000",
                    vat: "0.00000",
                    vat_definition_export_id: 5
                  }
                ],
                type: "EinzweckgutscheinKauf"
              },
              item: {
                number: 2,
                price_per_unit: "30.00000",
                quantity: 1
              },
              lineitem_export_id: 2,
              storno: false,
              text: nil
            }
          ]
        },
        security: {
          tss_tx_id: "00000000-0000-0000-0000-000000000000"
        }
      }
    ],
    client_id: 'fiskaly_client_id',
    cash_point_closing_export_id: 1
  }
)
```

#### DSFinV-K export download

https://developer.fiskaly.com/api/dsfinvk/v1#operation/getExportDownload

```ruby
FiskalyRuby.dsfinvk_exports_download(
  token: 'token',
  export_id: 'export_id'
)
```

#### DSFinV-K trigger export

https://developer.fiskaly.com/api/dsfinvk/v1#operation/triggerExport

```ruby
FiskalyRuby.dsfinvk_exports_trigger(
  token: access_token,
  export_id: export_id, # random uuid must be assigned in this case, ex: SecureRandom.uuid
  payload: {
    start_date: 81421343 # needs to be integer ex: Time.now.to_i
    end_date: 81421343 # needs to be integer ex: Time.now.to_i
  }
)
```

#### DSFinV-K retrieve export

https://developer.fiskaly.com/api/dsfinvk/v1#operation/retrieveExport

```ruby
FiskalyRuby.dsfinvk_exports_retrieve(
  token: 'access_token',
  export_id: 'export_id'
)
```

### KassenSichV API

#### Authenticate

https://developer.fiskaly.com/api/kassensichv/v2/#tag/Authentication

```ruby
FiskalyRuby.kassensichv_authenticate(
  api_key: 'fiskaly_api_key',
  api_secret: 'fiskaly_api_secret'
)
```

#### ADMIN authenticate

https://developer.fiskaly.com/api/kassensichv/v2/#operation/authenticateAdmin

```ruby
FiskalyRuby.kassensichv_admin_authenticate(
  token:   'access_token',
  tss_id:  'tss_id',
  payload: {
    admin_pin: 'fiskaly_admin_pin'
  }
)
```

#### ADMIN logut

https://developer.fiskaly.com/api/kassensichv/v2/#operation/logoutAdmin

```ruby
FiskalyRuby.kassensichv_admin_logout(
  token:  'access_token',
  tss_id: 'fiskaly_tss_id'
)
```

#### Change admin pin

https://developer.fiskaly.com/api/kassensichv/v2/#operation/changeAdminPin

```ruby
FiskalyRuby.kassensichv_tss_change_admin_pin(
  token:   'access_token',
  tss_id:  'tss_id',
  payload: {
    admin_puk:     'admin_puk',
    new_admin_pin: 'new_admin_pin'
  }
)
```

#### Create TSS

https://developer.fiskaly.com/api/kassensichv/v2/#operation/createTss

```ruby
FiskalyRuby.kassensichv_tss_create(
  token: 'access_token',
  tss_id: 'tss_id', # must send a random uuid, ex: SecureRandom.uuid
)
```

#### Initialize TSS

https://developer.fiskaly.com/api/kassensichv/v2/#operation/updateTss

```ruby
FiskalyRuby.kassensichv_tss_update(
  token: 'access_token',
  tss_id: 'tss_id',
  payload: { state: :UNINITIALIZED }
)
```

#### Deploy TSS

https://developer.fiskaly.com/api/kassensichv/v2/#operation/updateTss

```ruby
FiskalyRuby.kassensichv_tss_update(
  token: 'access_token',
  tss_id: 'tss_id',
  payload: { state: :INITIALIZED }
)
```

#### Retrieve TSS

https://developer.fiskaly.com/api/kassensichv/v2/#operation/retrieveTss

```ruby
FiskalyRuby.kassensichv_tss_retrieve(
  token: 'access_token',
  tss_id: 'tss_id',
)
```

#### Create Client (TSS)

https://developer.fiskaly.com/api/kassensichv/v2/#operation/createClient

```ruby
FiskalyRuby.kassensichv_tss_client_create(
  token: 'access_token',
  tss_id: 'tss_id'
)
```

#### Retrieve Client (TSS)

https://developer.fiskaly.com/api/kassensichv/v2/#operation/retrieveClient

```ruby
FiskalyRuby.kassensichv_tss_client_retrieve(
  token: 'access_token',
  tss_id: 'tss_id'
)
```

#### Retrieve TSS export

https://developer.fiskaly.com/api/kassensichv/v2#operation/retrieveExport

```ruby
FiskalyRuby.kassensichv_tss_export_retrieve(
  token: 'token',
  tss_id: 'fiskaly_tss_id',
  export_id: 'export_id'
)
```

#### Retrieve file TSS export

https://developer.fiskaly.com/api/kassensichv/v2#operation/retrieveExportFile

```ruby
FiskalyRuby.kassensichv_tss_export_retrieve_file(
  token: 'token',
  tss_id: 'fiskaly_tss_id',
  export_id: 'export_id'
)
```

#### Trigger TSS export

https://developer.fiskaly.com/api/kassensichv/v2#operation/triggerExport

```ruby
FiskalyRuby.kassensichv_tss_export_trigger(
  token: 'access_token',
  tss_id: 'tss_id',
  export_id: 'export_id', # random uuid, ex: SecureRandom.uuid
  payload: {
    start_date: 81421343 # needs to be integer ex: Time.now.to_i,
    end_date: 81421343 # needs to be integer ex: Time.now.to_i
  }
)
```

#### Start transaction (TSS)

https://developer.fiskaly.com/api/kassensichv/v2#operation/upsertTransaction

```ruby
FiskalyRuby.kassensichv_tss_tx_upsert(
  token: "access_token",
  tss_id: "tss_id",
  tx_revision: 1, # when you start a transaction, tx_revision is auto assigned to 1 by our gem, you can skip this if you want
  payload: {
    state: :ACTIVE,
    client_id: "client_id"
  }
)
```

#### Update/Finish transaction (TSS)

https://developer.fiskaly.com/api/kassensichv/v2#operation/upsertTransaction

```ruby
FiskalyRuby.kassensichv_tss_tx_upsert(
  token: "access_token",
  tss_id: "tss_id",
  tx_id_or_number: "00000000-0000-0000-0000-000000000000",
  tx_revision: 2,
  payload: {
    state: :FINISHED,
    client_id: "client_id",
    schema: {
      standard_v1: {
        receipt: {
          receipt_type: "RECEIPT",
          amounts_per_vat_rate: [
            {
              vat_rate: :NORMAL,
              :amount=>"150.00000"
            }
          ],
          amounts_per_payment_type: [
            {
              payment_type: :CASH,
              amount: "150.00000"
            }
          ]
        }
      }
    }
  }
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
