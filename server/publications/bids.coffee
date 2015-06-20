Meteor.publish 'bids', ->
    ShadowForGood.Collections.Bid.find {}