@ShadowForGood.Schema.ProviderSignup = ->
    {
        charity: {
            type: String
            label: 'Who do you want to donate the winnings to?'
            max: 250
        }
        charity_details: {
            type: String
            label: 'Charitz Bank Account Details (whatever you have: IBAN, BIC, etc....)'
        },
        skill: {
            type: String,
            label: 'What do you want to teach?'
            max: 50
        }
    }