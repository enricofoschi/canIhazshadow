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
    Pusher = Meteor.npmRequire('pusher')

    pusher = new Pusher(
        appId: '125998'
        key: '636c1f9e8ac0022ede0c'
        secret: '10c0d4e24a2997185c52'
    )

    pusher.trigger 'bids', 'add_bid', {
        "message": "hello world"
    }