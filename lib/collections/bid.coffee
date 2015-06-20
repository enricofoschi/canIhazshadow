class @ShadowForGood.Collections.Bid extends BaseCollection
    # indicate which collection to use
    @_collection: new Mongo.Collection('bids')

    @schema: {
        amount:
            type: Number
        user_id:
            type: String
        auction_id:
            type: String
    }