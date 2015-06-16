((template) =>

    template.events {

        'click .btn-login-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn (e, r) ->
                Router.go '/candidate/ftuf'

        'click .btn-login-xing' : (e, t) ->
            Meteor.loginWithXing (e, r) ->
                Router.go '/candidate/ftuf'

    }

)(Helpers.Client.TemplatesHelper.Handle('login'))