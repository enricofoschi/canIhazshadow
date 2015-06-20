((template) =>

    template.events {
        'click .btn-signout': ->
            Meteor.logout()
    }

)(Helpers.Client.TemplatesHelper.Handle('presentation_header'))