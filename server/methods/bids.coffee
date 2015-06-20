Meteor.methods {
    'placeBid': (masterId) ->
        master = new MeteorUser masterId

        currentBid = master.profile.shadow_for_good.bid || 0
        nextBid = currentBid + 1

        master.update {
            $set:
                'profile.bidder': true
                'profile.shadow_for_good.bid': nextBid
                'profile.shadow_for_good.bidder': Meteor.userId()
        }

        ShadowForGood.Collections.Bid.create {
            user_id: Meteor.userId()
            bid: nextBid
        }

}