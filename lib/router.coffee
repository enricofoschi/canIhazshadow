# Presentation stuff
PresentationController = RouteController.extend {
    layoutTemplate: 'PresentationLayout'
    onAfterAction: ->
        Blaze.addBodyClass 'presentation'
        Blaze.addBodyClass ->
            Router.current() and Router.current().route.getName()
        window.initApp();
}

Router.route '/', {
    controller: PresentationController
    name: 'presentation_home_main'
    action: ->
        @render 'presentation.home.main'
        return
}

Router.route '/payment', {
    controller: PresentationController
    name: 'presentation_payment_index'
    action: ->
        @render 'presentation.payment.index'
        return
}

Router.route '/approve/:id', {
    controller: PresentationController
    name: 'presentation_home_approved'
    action: ->

        Helpers.Client.MeteorHelper.CallMethod {
            method: 'approveCharity'
            params: [@params.id]
            callback: (e, r) =>
                if not e
                    Helpers.Client.Notifications.Success 'User approved :)'
        }

        Router.go '/'
        return
}

# Admin stuff
adminRoles = ['admin']

AdminController = RouteController.extend {
    layoutTemplate: 'AdminLayout'

    onBeforeAction: ->
        if not Roles.userIsInRole Meteor.userId(), ['hr']
            Router.go '/login'
        else
            @next()
    waitOn: ->
        [
            Meteor.subscribe 'calendars'
            Meteor.subscribe 'departments'
            Meteor.subscribe 'interviews'
        ]
    onAfterAction: ->
        Blaze.addBodyClass 'admin'
        Blaze.addBodyClass ->
            Router.current() and Router.current().route.getName()
        Session.set('refresh', Math.random()) # Used to refresh sidebar menu
        $('#side-menu .active').removeClass('active')
}