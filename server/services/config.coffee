@Services = _.extend @Services, {
    TWILIO:
        key: 'twilio'
        service: ->
            number = Meteor.settings.twilio.number
            sid = Meteor.settings.twilio.sid
            token = Meteor.settings.twilio.token

            return new Crater.Services.ThirdParties.TwilioService number, sid, token
}

@Crater.Services.InitAll()