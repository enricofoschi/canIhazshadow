((template) =>

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    chosenAuction = null

    template.onCustomCreated = ->
        chosenAuction = null

    onLogin = (e) =>

        if not e
            # shitty way to find out if modal is open
            if chosenAuction
                Helpers.Client.Modal.Close()
                onChosenAuction()
            else
                Roles.addUsersToRoles Meteor.userId(), ['master']

    onChosenAuction = ->
        Router.go '/auction/' + chosenAuction._id

    template.events {

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn onLogin

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook onLogin

        'click .btn-continue-twitter': (e, t) ->
            Meteor.loginWithTwitter onLogin

        'click .btn-place-bid': (e, t) ->

            chosenAuction = @

            if not Meteor.userId()
                Helpers.Client.Modal.Show {
                    identifier: 'signupDialog'
                }
            else
                onChosenAuction()

    }

    currentBid = (shadowMaster) ->
        shadowMaster.profile.shadow_for_good.bid || 1

    template.helpers {
        currentBid: ->
            currentBid @shadowMaster
        newAmount: ->
            currentBid(@shadowMaster) + 1
    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.auction.main'))