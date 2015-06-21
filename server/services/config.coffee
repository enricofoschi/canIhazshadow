@Services = _.extend @Services, {
    TWILIO:
        key: 'twilio'
        service: ->
            if Meteor.settings.twilio
                number = Meteor.settings.twilio?.number
                sid = Meteor.settings.twilio?.sid
                token = Meteor.settings.twilio?.token

            else
                return {}
}

@Crater.Services.InitAll()