Meteor.publish 'bidders', ->
    Meteor.users.find {
            'profile.bidder': true
        },
        {
            fields:
                'services.facebook.id': 1
                'services.facebook.name': 1
                'services.facebook.first_name': 1
                'services.linkedin.id': 1
                'services.linkedin.firstName': 1
                'services.linkedin.lastName': 1
                'services.linkedin.profile.formattedName': 1
                'services.linkedin.profile.pictureUrls': 1
                'profile.shadow_for_good': 1
        }