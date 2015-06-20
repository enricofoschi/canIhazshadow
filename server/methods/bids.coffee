Meteor.methods {
    'placeBid': (masterId, bid) ->
        master = new MeteorUser masterId

        currentBid = master.profile.shadow_for_good.bid || 0

        nextBid = parseInt bid

        if nextBid <= currentBid
            throw 'LOW'

        master.update {
            $set:
                'profile.shadow_for_good.bid': nextBid
                'profile.shadow_for_good.bidder': Meteor.userId()
        }

        currentUser = new MeteorUser Meteor.user()

        currentUser.update {
            $set:
                'profile.bidder': true
        }

        ShadowForGood.Collections.Bid.create {
            user_id: Meteor.userId()
            amount: nextBid
            auction_id: masterId
        }

}