@Services = _.extend @Services, {
    TWILIO:
        key: 'twilio'
        service: ->
            if Meteor.settings.twilio
                number = Meteor.settings.twilio?.number
                sid = Meteor.settings.twilio?.sid
                token = Meteor.settings.twilio?.token

                return new Crater.Services.ThirdParties.TwilioService number, sid, token
            else
                return {}
    PUSHER:
        key: 'pusher'
        service: ->
            if Meteor.settings.pusher
                appId = Meteor.settings.pusher?.appId
                key = Meteor.settings.pusher?.key
                secret = Meteor.settings.pusher?.secret

                return new Crater.Services.ThirdParties.PusherService appId, key, secret
            else
                return {}
}

@Crater.Services.InitAll()