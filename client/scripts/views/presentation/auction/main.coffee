((template) =>

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    chosenAuction = null

    onLogin = (e) ->
        if not e
            Helpers.Client.MeteorHelper.CallMethod {
                method: 'placeBid'
                params: [template.currentInstance.data.shadowMaster._id]
            }
            Helpers.Client.Modal.Close()

    template.onCustomCreated = ->
        chosenAuction = null

    onChosenAuction = ->
        Router.go '/auction/' + chosenAuction._id

    template.events {

        'click .btn-place-bid' : (e, t) ->
            if not Meteor.userId()
                Helpers.Client.Modal.Show {
                    identifier: 'signupDialog'
                }
            else
                Helpers.Client.MeteorHelper.CallMethod {
                    method: 'placeBid'
                    params: [@shadowMaster._id]
                }

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn onLogin

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook onLogin

        'click .btn-continue-twitter': (e, t) ->
            Helpers.Client.Notifications.Error 'Woah Buddy! Twitter likez no lolz. Their app creation Suckz (and it was broken this weekend)'

    }

    currentBid = (shadowMaster) ->
        shadowMaster.profile.shadow_for_good.bid || 1

    template.helpers {
        bidderFullName: ->
            console.log @shadowMaster.profile.shadow_for_good?.bidder
            if @shadowMaster.profile.shadow_for_good?.bidder
                user = new MeteorUser @shadowMaster.profile.shadow_for_good?.bidder
                return user.getFullName()
            return ''
        bidderProfilePicture: ->
            if @shadowMaster.profile.shadow_for_good?.bidder
                user = new MeteorUser @shadowMaster.profile.shadow_for_good?.bidder
                return user.getProfilePicture()
            return ''
        isWinner: ->
            @shadowMaster.profile.shadow_for_good?.bidder is Meteor.userId()
        hasBid: ->
            @shadowMaster.profile.shadow_for_good?.bid > 0
        currentBid: ->
            currentBid @shadowMaster
        newAmount: ->
            currentBid(@shadowMaster) + 1
    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.auction.main'))