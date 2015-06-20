class @Helpers.ShadowForGood.Puppy

    @GetRandomName: ->

        found = false
        code = null

        while not found
            code = _.sample(GlobalSettings.names, 1)[0] + Math.round(Math.random() * 10)

            found = Meteor.users.find({
                    'profile.shadow_for_good.code': code
            }).fetch().length is 0

        code