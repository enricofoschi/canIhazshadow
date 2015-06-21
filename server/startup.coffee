Meteor.startup ->
    ServiceConfiguration.configurations.remove {}
    ServiceConfiguration.configurations.insert {
        service: "xing",
        consumerKey: Meteor.settings.xing.key,
        secret: Meteor.settings.xing.secret
    }
    ServiceConfiguration.configurations.insert {
        service: "linkedin",
        clientId: Meteor.settings.linkedin.clientId,
        secret: Meteor.settings.linkedin.secret
    }
    ServiceConfiguration.configurations.insert {
        service: "facebook",
        appId: Meteor.settings.facebook.appId,
        secret: Meteor.settings.facebook.secret
    }

    # Temp for pusher testing
#    Pusher = Meteor.npmRequire('pusher')
#
#    pusher = new Pusher(
#        appId: Meteor.settings.pusher.appId
#        key: Meteor.settings.pusher.key
#        secret: Meteor.settings.pusher.secret
#    )
#
#    pusher.trigger 'bids', 'add_bid', 'message': 'hello world'
