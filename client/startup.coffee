Global = @

Meteor.startup ->
    BaseCollection.InitCollections()

    # pusher client for test.
    pusher = new Pusher("636c1f9e8ac0022ede0c");

    channel = pusher.subscribe('bids');

    channel.bind 'new_bid', (data)->
        console.log data
        return