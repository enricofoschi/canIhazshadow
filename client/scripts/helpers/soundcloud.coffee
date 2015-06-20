class @Helpers.Client.ShadowForGood.SoundCloud

    @Play: (track) =>
        if track
            SC.stream(GlobalSettings.soundcloud.url + track, (sound) ->
                sound.play()
                return
            )

    Meteor.startup ->
        SC.initialize {
            client_id: GlobalSettings.soundcloud.clientId
        }