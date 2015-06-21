# TODO move code to services layer

Meteor.startup ->

    SyncedCron.add {
        name: 'Check Events'
        schedule: (parser) ->
            return parser.text('every 5 seconds')
        job: ->
            users = Meteor.users.find({
                'profile.shadow_for_good.terminates':
                    $lte: (new Date()).getTime()
                'profile.shadow_for_good.status': 'approved'
            }).fetch()

            for user in users
                meteorUser = new MeteorUser user
                meteorUser.update {
                    $set:
                        'profile.shadow_for_good.status': 'terminated'
                }

                bidder = meteorUser.profile.shadow_for_good.bidder

                if bidder
                    bidderUser = new MeteorUser bidder
                    email = bidderUser.getEmail()
                    phone = bidderUser.profile.phone

                    if email
                        Helpers.Server.ShadowForGood.Email.Send {
                            template: 'won'
                            subject: 'You got it'
                            data: {
                                skill: meteorUser.profile.shadow_for_good.skill
                                charity: meteorUser.profile.shadow_for_good.charity
                                amount: meteorUser.profile.shadow_for_good.bid
                                master: meteorUser.getFullName()
                                url: Meteor.absoluteUrl 'pay/' + meteorUser._id
                            }
                            to: email
                            from: 'noreply@shadowforgood.de'
                        }
                    if phone
                        console.log 'Send SMS'
    }


    SyncedCron.start()