Meteor.methods {
    'setCharity': (attr) ->
        user = new MeteorUser Meteor.user()

        attr.status = 'validation'
        attr.bid = 10

        user.update {
            $set:
                'profile.shadow_for_good': attr
        }

        Helpers.Server.ShadowForGood.Email.Send {
            template: 'approve'
            subject: 'Subject'
            data: {
                sender: user.getFullName()
                skill: user.profile.shadow_for_good.skill
                charity: user.profile.shadow_for_good.charity
                charityDetails: user.profile.shadow_for_good.charity_details
                url: Meteor.absoluteUrl 'approve/' + user._id
            }
            to: 'foschi.enrico@gmail.com'
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
                }

                Helpers.Server.ShadowForGood.Email.Send {
                    template: 'approved'
                    subject: 'Subject'
                    data: {
                        firstName: user.getFirstName()
                        url: Meteor.absoluteUrl 'auction/' + user._id
                    }
                    to: user.getEmail()
                    from: 'noreply@shadowforgood.de'
                }
        else
            throw 'Damn, no authorization'

}