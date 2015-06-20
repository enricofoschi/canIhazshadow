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

        'click .btn-place-bid' : (e, t) ->
            console.log @shadowMaster

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