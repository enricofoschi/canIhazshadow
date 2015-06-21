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
