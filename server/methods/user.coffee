Meteor.methods {
    'setCharity': (attr) ->
        user = new MeteorUser Meteor.user()

        attr.status = 'validation'
        attr.bid = 10
        attr.code = Helpers.ShadowForGood.Puppy.GetRandomName()

        user.update {
            $set:
                'profile.shadow_for_good': attr
        }

        ShadowForGood.Collections.Bid.destroyAll {
            auction_id: user._id
        }

        Helpers.Server.ShadowForGood.Email.Send {
            template: 'approve'
            subject: 'Approve a new shadowing'
            data: {
                sender: user.getFullName()
                skill: user.profile.shadow_for_good.skill
                charity: user.profile.shadow_for_good.charity
                charityDetails: user.profile.shadow_for_good.charity_details
                url: Meteor.absoluteUrl 'approve/' + user._id
            }
            to: Meteor.settings.approverEmail
            from: 'noreply@shadowforgood.de'
        }

    'approveCharity': (id) ->
        currentUser = new MeteorUser Meteor.user()
        if currentUser.isAdminByEmail()
            user = new MeteorUser id

            if user.registered
                user.update {
                    $set:
                        'profile.shadow_for_good.status': 'approved'
                        'profile.shadow_for_good.terminates': (new Date()).getTime() + GlobalSettings.auctionDuration
                }

                Helpers.Server.ShadowForGood.Email.Send {
                    template: 'approved'
                    subject: 'You have been approved'
                    data: {
                        firstName: user.getFirstName()
                        url: Meteor.absoluteUrl 'auction/' + user._id
                    }
                    to: user.getEmail()
                    from: 'noreply@shadowforgood.de'
                }
        else
            throw 'Damn, no authorization'

    'getClientSettings': ->
        return {
            twilioNumber: Meteor.settings.twilio.number
        }
}