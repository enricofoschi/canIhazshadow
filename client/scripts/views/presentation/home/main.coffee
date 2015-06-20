((template) =>

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    template.events {

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn()

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook()

        'click .btn-continue-twitter': (e, t) ->
            Meteor.loginWithTwitter()

    }

    template.helpers {
        providerSchema: ->
            Crater.Schema.Get ShadowForGood.Schema.ProviderSignup
    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.home.main'))