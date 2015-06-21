@ShadowForGood.Schema.ProviderSignup = ->
    {
        charity: {
            type: String
            label: 'Your Charity'
            max: 250
        }
        charity_details: {
            type: String
            label: 'Charity Payment Details'
        },
        skill: {
            type: String,
            label: 'What can you teach?'
            max: 50
        }
        skill_details: {
            type: String,
            label: 'What would they learn?'
        }
    }