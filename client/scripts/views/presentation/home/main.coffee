((template) =>

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    chosenAuction = null

    template.onCustomCreated = ->
        chosenAuction = null

    onLogin = (e) =>

        if not e
            # shitty way to find out if modal is open
            if chosenAuction
                Helpers.Client.Modal.Close()
                onChosenAuction()

    onChosenAuction = ->
        Router.go '/auction/' + chosenAuction._id

    template.events {

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn onLogin

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook onLogin

        'click .btn-continue-twitter': (e, t) ->
            Helpers.Client.Notifications.Error 'Woah Buddy! Twitter likez no lolz. Their app creation Suckz (and it was broken this weekend)'

        'click .btn-place-bid': (e, t) ->

            Router.go '/auction/' + @_id

    }

    template.helpers {
        isMaster: ->
            user = new MeteorUser Meteor.user()
            return user.profile.shadow_for_good
        providerSchema: ->
            Crater.Schema.Get ShadowForGood.Schema.ProviderSignup
        isApproved: ->
            user = new MeteorUser Meteor.user()
            user.profile.shadow_for_good.status is 'approved'
        isValidating: ->
            user = new MeteorUser Meteor.user()
            user.profile.shadow_for_good.status is 'validation'
        charity: ->
            user = new MeteorUser Meteor.user()
            user.profile.shadow_for_good?.charity
        charityDetails: ->
            user = new MeteorUser Meteor.user()
            user.profile.shadow_for_good?.charity_details
        skill: ->
            user = new MeteorUser Meteor.user()
            user.profile.shadow_for_good?.skill

        masterFullName: (user) ->
            user = new MeteorUser user
            user.getFullName()

        masterSkill: (user) ->
            user = new MeteorUser user
            user.profile.shadow_for_good.skill

        masterCharity: (user) ->
            user = new MeteorUser user
            user.profile.shadow_for_good.charity

        masterPicture: (user) ->
            user = new MeteorUser user
            user.getProfilePicture()
    }

    Meteor.startup ->
        @AutoForm.hooks {
            insertCharityForm: Helpers.Client.Form.GetFormHooks {
                onSuccess: ->
                    Helpers.Client.Notifications.Success 'That\'s super awesome! We will review this and get back to you!', 'Thank you, Master!'
            }
        }

)(Helpers.Client.TemplatesHelper.Handle('presentation.home.main'))