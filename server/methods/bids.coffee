Meteor.methods {
    'placeBid': (masterId, bid, bidderId = null) ->
        master = new MeteorUser masterId

        currentBid = master.profile.shadow_for_good.bid || 0

        nextBid = parseInt bid

        if nextBid <= currentBid
            throw 'LOW'

        master.update {
            $set:
                'profile.shadow_for_good.bid': nextBid
                'profile.shadow_for_good.bidder': bidderId || Meteor.userId()
        }

        currentUser = new MeteorUser bidderId || Meteor.user()

        currentUser.update {
            $set:
                'profile.bidder': true
        }

        ShadowForGood.Collections.Bid.create {
            user_id: bidderId || Meteor.userId()
            amount: nextBid
            auction_id: masterId
        }

        pusher = Crater.Services.Get Services.PUSHER
        console.log 'Triggering'
        pusher.trigger 'bids', 'new_bid', {
            bid: bid
            masterId: masterId
            from: bidderId || Meteor.userId()
        }

}