((template) =>

    onLogin = ->
        Router.go '/candidate/ftuf'

    template.events {

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn (e, r) ->
                onLogin()

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook (e, r) ->
                onLogin()

        'click .btn-continue-twitter': (e, t) ->
            Meteor.loginWithTwitter (e, r) ->
                onLogin()

    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.home.main'))