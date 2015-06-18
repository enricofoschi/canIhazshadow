((template) =>

    onLogin = ->
        Router.go '/candidate/ftuf'

    template.events {

        'click .btn-login-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn (e, r) ->
                onLogin()

        'click .btn-login-xing' : (e, t) ->
            Meteor.loginWithXing (e, r) ->
                onLogin()

    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.home.main'))