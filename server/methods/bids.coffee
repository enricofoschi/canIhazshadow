Meteor.methods {
    'placeBid': (masterId) ->
        master = new MeteorUser masterId

        currentBid = master.profile.shadow_for_good.bid || 0
        nextBid = currentBid + 1

        master.update {
            $set:
                'profile.shadow_for_good.bid': nextBid
        }

}