Meteor.methods {
    'twilio.sendSms': (targetNumber, body) ->
        twilioService = Crater.Services.Get Services.TWILIO
        twilioService.sendSms targetNumber, body
}
