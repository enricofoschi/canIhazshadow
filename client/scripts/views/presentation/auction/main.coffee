((template) =>

    countDown = new ReactiveVar(null)
    counterInterval = null

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    channel = 'bids'
    event = 'add_bid'
    data = 'message: test'

    console.log 'gets here'
    Meteor.call 'pusherSubscribe', channel, event, data

    console.log 'event triggered'

    chosenAuction = null

    onLogin = (e) ->
        if not e
            Helpers.Client.MeteorHelper.CallMethod {
                method: 'placeBid'
                params: [
                    template.currentInstance.data.shadowMaster._id
                    getNumber()
                ]
                callback: bidCallback
            }
            Helpers.Client.Modal.Close()

    bidCallback = (e, r)=>
        if e is 'LOW' or e
            Helpers.Client.Notifications.Error 'Please enter a bid amount higher than the current bid'
        else
            Helpers.Client.Notifications.Success 'Your bid is confirmed.', 'Awesome!'

    template.onCustomCreated = ->
        chosenAuction = null
        countDown.set(null)
        if counterInterval
            clearInterval(counterInterval)
            counterInterval = null

    # HACKING THE SHIT OUT OF IT
    addZero = (str) =>
        if str.toString().length is 1
            return '0' + str
        return str

    template.rendered = ->
        eventTime= template.currentInstance.data.shadowMaster.profile.shadow_for_good.terminates
        interval = 500

        counterInterval = setInterval ->
            currentTime = (new Date()).getTime()
            diffTime = eventTime - currentTime
            duration = moment.duration(diffTime, 'milliseconds')

            if diffTime < 0
                clearInterval counterInterval
                counterInterval = null
                countDown.set null
            else
                countDown.set(addZero(duration.hours()) + ":" + addZero(duration.minutes()) + ":" + addZero(duration.seconds()))
        , interval

    onChosenAuction = ->
        Router.go '/auction/' + chosenAuction._id

    getNumber = =>
        val = parseInt($('.txt-number').val())
        if not val
            Helpers.Client.Notifications.Error 'Please enter a valid number'
            throw 'Please enter a number'

        val


    template.events {

        'click .btn-place-bid' : (e, t) ->
            if not Meteor.userId()
                Helpers.Client.Modal.Show {
                    identifier: 'signupDialog'
                }
            else
                Helpers.Client.MeteorHelper.CallMethod {
                    method: 'placeBid'
                    params: [
                        @shadowMaster._id
                        getNumber()
                    ]
                    callback: bidCallback
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
        countDown: ->
            countDown.get()
        bidderFullName: ->
            if @shadowMaster.profile.shadow_for_good?.bidder
                user = new MeteorUser @shadowMaster.profile.shadow_for_good?.bidder
                return user.getFullName()
            return ''
        bidderProfilePicture: ->
            if @shadowMaster.profile.shadow_for_good?.bidder
                user = new MeteorUser @shadowMaster.profile.shadow_for_good?.bidder
                return user.getProfilePicture()
            return ''
        isApproved: ->
            @shadowMaster.profile.shadow_for_good?.status is 'approved'
        isTerminated: ->
            @shadowMaster.profile.shadow_for_good?.status is 'terminated'
        isWinner: ->
            @shadowMaster.profile.shadow_for_good?.bidder is Meteor.userId()
        hasBid: ->
            @shadowMaster.profile.shadow_for_good?.bid > 0 and @shadowMaster.profile.shadow_for_good?.bidder
        currentBid: ->
            currentBid @shadowMaster
        newAmount: ->
            currentBid(@shadowMaster) + 1

        previousBidderProfilePicture: (user_id) ->
            user = new MeteorUser user_id
            return user.getProfilePicture()

        previousBidderFullName: (user_id) ->
            user = new MeteorUser user_id
            return user.getFullName()
    }

)(Helpers.Client.TemplatesHelper.Handle('presentation.auction.main'))