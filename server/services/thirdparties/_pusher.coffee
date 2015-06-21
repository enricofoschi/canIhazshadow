class @Crater.Services.ThirdParties.PusherService extends @Crater.Services.ThirdParties.Base

    _pusher: null
    Pusher = Meteor.npmRequire('pusher')

    constructor: (appId, key, secret) ->
        @_pusher = new Pusher({
            appId: appId,
            key: key,
            secret: secret
        });

    trigger: (channel, event, data) ->
        @_pusher.trigger channel, event, data
