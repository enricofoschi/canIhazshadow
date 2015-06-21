class @Crater.Services.ThirdParties.PusherService extends @Crater.Services.ThirdParties.Base

    pusher = Meteor.npmRequire('pusher')

    _appId: null
    _key: null
    _secret: null
    _pusher: null

    constructor: (appId, key, secret) ->
        @_appId = appId
        @_key = key
        @_secret = secret

        @_pusher = new pusher(
            appId
            key
            secret
        )

    trigger: (channel, event, data) ->
        console.log 'getting pusher internal variable'
        console.log @_pusher
        @_pusher.trigger channel, event, data

    subscribe: (channel, event) ->
        channelObj = @_pusher.subscribe channel
        channelObj.bind event, (data) ->
            console.log 'test'
            console.log data

    unsubscribe: (channel, event) ->
        @_pusher.unsubscribe channel, event
