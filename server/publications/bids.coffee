Meteor.publish 'bids', (auctionId) ->
    ShadowForGood.Collections.Bid.find {
        auction_id: auctionId
    }