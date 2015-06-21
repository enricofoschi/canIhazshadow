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

Router.route '/pay/:id', {
    controller: PresentationController
    name: 'presentation_payment_index'
    action: ->

        shadowMaster = new MeteorUser Meteor.users.findOne {
            _id: @params.id
        }

        console.log Meteor.userId() + ' - ' + shadowMaster.profile.shadow_for_good.bidder
        if Meteor.userId() isnt shadowMaster.profile.shadow_for_good.bidder or shadowMaster.profile.shadow_for_good.paid
            Router.go '/'

        @render 'presentation.payment.index', {
            data:
                shadowMaster: shadowMaster
        }
        return
}

Router.route '/bid/receive/sms', {
    name: 'presentation_bid_receive_sms'
    where: 'server'
    action: ->
        console.log 'Bid from mobile'

        phone = @request.body.From

        body = @request.body.Body.split ' '
        shadowMasterCode = body[0]
        bid = body[1]

        bidder = Meteor.users.findOne {
            'profile.phone': phone
        }

        if !bidder
            Meteor.users.insert {
                profile: {
                    phone: phone
                }
            }
            bidder = Meteor.users.findOne {
                'profile.phone': phone
            }

        console.log shadowMasterCode.toLowerCase()

        shadowMaster = Meteor.users.findOne {
            'profile.shadow_for_good.code': shadowMasterCode.toLowerCase()
        }

        console.log shadowMaster
        console.log bid


        if shadowMaster and shadowMaster.profile.shadow_for_good.status is 'approved' and bid
            Meteor.call 'placeBid', shadowMaster._id, bid, bidder._id
            console.log 'Succeeded: ' + bid

        @response.end ''
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
                        createdAt: -1
                    }
                }).fetch()
        }
        return
}

Busboy = null

if Meteor.isServer
    Busboy = Meteor.npmRequire "Busboy"

Router.route '/bid/receive/email', {
    name: 'presentation_bid_receive_email'
    where: 'server'
    onBeforeAction: (req, res, next) ->

        fields = {}

        busboy = new Busboy {
            headers: req.headers
        }
        busboy.on "field", (fieldname, value) =>
            fields[fieldname] = value

        busboy.on "finish", ->
            req.fields = fields
            next()

        req.pipe(busboy)

    action: ->
        fields = @request.fields

        emailFrom = EJSON.parse(fields.envelope).from

        console.log emailFrom

        codesList = fields.text.match(/\S+ \S+/)
        if codesList and codesList.length
            codes = codesList[0].split ' '
            bid = parseInt codes[1]

            bidder = Meteor.users.findOne {
                emails:
                    $elemMatch:
                        address: emailFrom
            }

            if not bidder
                Accounts.createUser {
                    email: emailFrom
                    password: ''
                    profile: {}
                }

            bidder = Meteor.users.findOne {
                emails:
                    $elemMatch:
                        address: emailFrom
            }

            shadowMaster = Meteor.users.findOne {
                'profile.shadow_for_good.code': codes[0].toLowerCase()
            }

            if shadowMaster and shadowMaster.profile.shadow_for_good.status is 'approved' and bid
                Meteor.call 'placeBid', shadowMaster._id, bid, bidder._id
                console.log 'Succeeded: ' + bid

        @response.end ''
}