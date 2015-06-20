((template) =>

    Helpers.Client.Application.addCallbacksToTemplate template.viewName, [
        'adaptive-label'
    ]

    template.events {

        'click .btn-continue-linkedin' : (e, t) ->
            Meteor.loginWithLinkedIn()

        'click .btn-continue-facebook' : (e, t) ->
            Meteor.loginWithFacebook()

        'click .btn-continue-twitter': (e, t) ->
            Meteor.loginWithTwitter()

    }

    template.helpers {
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
    }

    Meteor.startup ->
        @AutoForm.hooks {
            insertCharityForm: Helpers.Client.Form.GetFormHooks {
                onSuccess: ->
                    Helpers.Client.Notifications.Success 'That\'s super awesome! We will review this and get back to you!', 'Thank you, Master!'
            }
        }

)(Helpers.Client.TemplatesHelper.Handle('presentation.home.main'))