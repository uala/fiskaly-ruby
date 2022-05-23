
RSpec.describe FiskalyRuby::DSFinVK::CashPointClosing::Create do
  let(:payload) do
    {
      client_id: ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_fiskaly_client_id'),
      cash_point_closing_export_id: 1,
      head: {
        export_creation_date: '1645710845',
        first_transaction_export_id: '5c02cb04-f028-481a-8e28-8b52ca64ec32',
        last_transaction_export_id: '348b62ae-4d2e-4d4f-8e51-b5bb2cc19258'
      },
      cash_statement: {
        business_cases: [
          {
            type: 'Umsatz',
            amounts_per_vat_id: [
              {
                vat_definition_export_id: 1,
                incl_vat: 28.56,
                excl_vat: 24.00,
                vat: 4.56
              }
            ]
          }
        ],
        payment: {
          full_amount: 28.56,
          cash_amount: 28.56,
          cash_amounts_by_currency: [
            {
              currency_code: 'EUR',
              amount: 28.56
            }
          ],
          payment_types: [
            {
              type: 'Bar',
              currency_code: 'EUR',
              amount: 28.56
            }
          ]
        }
      },
      transactions: [
        {
          head: {
            tx_id: '5c02cb04-f028-481a-8e28-8b52ca64ec32',
            transaction_export_id: 'tx_1',
            closing_client_id: ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_fiskaly_client_id'),
            type: 'Beleg',
            storno: false,
            number: 1,
            timestamp_start: 1645710394,
            timestamp_end: 1645710397,
            user: {
              user_export_id: 'ich',
              name: 'Ich'
            },
            buyer: {
              name: 'Client Name',
              buyer_export_id: '1',
              type: 'Kunde'
            },
            references: [
              {
                type: 'ExterneRechnung',
                external_export_id: '1234'
              }
            ]
          },
          data: {
            full_amount_incl_vat: 14.28,
            payment_types: [
              {
                type: 'Bar',
                currency_code: 'EUR',
                amount: 14.28
              }
            ],
            amounts_per_vat_id: [
              {
                vat_definition_export_id: 1,
                incl_vat: 14.28,
                excl_vat: 12.00,
                vat: 2.28
              }
            ],
            lines: [
              {
                business_case: {
                  type: 'Umsatz',
                  amounts_per_vat_id: [
                    {
                      vat_definition_export_id: 12,
                      incl_vat: 14.28,
                      excl_vat: 12,
                      vat: 2.28
                    }
                  ]
                },
                lineitem_export_id: '1',
                storno: true,
                text: 'Sonstiges',
                item: {
                  number: 'A',
                  quantity: 1.0,
                  price_per_unit: 12
                }
              }
            ]
          },
          security: {
            tss_tx_id: '5c02cb04-f028-481a-8e28-8b52ca64ec32'
          }
        },
        {
          head: {
            tx_id: '348b62ae-4d2e-4d4f-8e51-b5bb2cc19258',
            transaction_export_id: 'tx_2',
            closing_client_id: ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_fiskaly_client_id'),
            type: 'Beleg',
            storno: false,
            number: 1,
            timestamp_start: 1645710401,
            timestamp_end: 1645710403,
            user: {
              user_export_id: 'ich',
              name: 'Ich'
            },
            buyer: {
              name: 'Client Name',
              buyer_export_id: '2',
              type: 'Kunde'
            },
            references: [
              {
                type: 'ExterneRechnung',
                external_export_id: '1234'
              }
            ]
          },
          data: {
            full_amount_incl_vat: 14.28,
            payment_types: [
              {
                type: 'Bar',
                currency_code: 'EUR',
                amount: 14.28
              }
            ],
            amounts_per_vat_id: [
              {
                vat_definition_export_id: 1,
                incl_vat: 14.28,
                excl_vat: 12.00,
                vat: 2.28
              }
            ],
            lines: [
              {
                business_case: {
                  type: 'Umsatz',
                  amounts_per_vat_id: [
                    {
                      vat_definition_export_id: 11,
                      incl_vat: 14.28,
                      excl_vat: 12,
                      vat: 2.28
                    }
                  ]
                },
                lineitem_export_id: '1',
                storno: true,
                text: 'Sonstiges',
                item: {
                  number: 'A',
                  quantity: 1.0,
                  price_per_unit: 12
                }
              }
            ]
          },
          security: {
            tss_tx_id: '348b62ae-4d2e-4d4f-8e51-b5bb2cc19258'
          }
        }
      ]
    }
  end

  it 'inherits from "FiskalyRuby::DSFinVK::Base" class' do
    expect(described_class).to be < FiskalyRuby::DSFinVK::Base
  end

  describe '.call'do

    context 'with successful response' do
      let(:create_call) do
        described_class.call(
          token: ENV.fetch('RSPEC_FISKALY_TOKEN', 'some_fiskaly_token'),
          closing_id: '854033f7-8dd2-4ebc-bbf5-6c83970346cf',
          payload: payload
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/cash_point_closing_ok' }

      it 'receives an succesful response', vcr: vcr_options do
        expect(create_call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with failed response' do
      let(:create_call) do
        described_class.call(
          token: 'some_wrong_fiskaly_token',
          closing_id: '78ef6544-f7f7-407f-847e-1709921bae3e',
          payload: payload
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/cash_point_closing_error' }

      it 'receives error response', vcr: vcr_options do
        expect(create_call[:status]).to eq :error
      end
    end
  end
end
