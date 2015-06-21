Global = @

Meteor.startup ->
    BaseCollection.InitCollections()



#    console.log 'im here'
#    # pusher client for test.
#    pusher = new Pusher("636c1f9e8ac0022ede0c");
#
#    channel = pusher.subscribe('bids');
#
#    console.log 'testing'
#
#    channel.bind 'add_bid', (data) ->
#        console.log 'test'
#        console.log data
#        console.log data.message
#        console.log 'gets here'
#
#    console.log 'gets finall here'

