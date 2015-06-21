# Presentation stuff
PresentationController = RouteController.extend {
    layoutTemplate: 'PresentationLayout'
    waitOn: -> [
        Meteor.subscribe 'shadow-masters'
    ]
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

        shadowMasters = Meteor.users.find({
            'profile.shadow_for_good.status': 'approved'
        }).fetch().toMatrix(4)

        @render 'presentation.home.main', {
            data:
                shadowMasters: shadowMasters
        }
        return
}

Router.route '/payment', {
    controller: PresentationController
    name: 'presentation_payment_index'
    action: ->
        @render 'presentation.payment.index'
        return
}

Router.route '/bid/receive/sms', {
    name: 'presentation_bid_receive_sms'
    where: 'server'
    action: ->
        Meteor.users.insert {
            profile: {
                phone: @request.body.From
            }
        }

        shadowMaster = Meteor.users.findOne {
            'profile.shadow_for_good.code': yourCode
        }

        if shadowMaster

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

Router.route '/auction/:id', {
    controller: PresentationController
    name: 'presentation_auction_main'
    waitOn: ->
        [
            Meteor.subscribe 'bidders'
            Meteor.subscribe 'bids', @params.id
        ]
    action: ->
        @render 'presentation.auction.main', {
            data:
                shadowMaster: new MeteorUser Meteor.users.findOne {
                    _id: @params.id
                }
                previousBids: ShadowForGood.Collections.Bid.find({}, {
                    sort: {
                        createdAt: 0
                    }
                }).fetch()
        }
        return
}