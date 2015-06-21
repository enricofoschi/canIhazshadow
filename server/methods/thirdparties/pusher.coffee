Meteor.methods {
    'pusherTrigger': (channel, event, data) ->
        console.log arguments
        console.log 'before service get'
        pusherService = Crater.Services.Get Services.PUSHER
        console.log 'about to trigger'
        console.log pusherService
        pusherService.trigger channel, event, data
    'pusherSubscribe': (channel, event) ->
        pusherService = Crater.Services.Get Services.PUSHER
        pusherService.subscribe channel, event
    'pusherUnsubscribe': (channel, event) ->
        pusherService = Crater.Services.Get Services.PUSHER
        pusherService.unsubscribe channel, event
}
