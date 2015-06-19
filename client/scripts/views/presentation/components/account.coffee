((template) =>

    signupFormSchema = null

    template.onCustomCreated = ->
        signupFormSchema = Crater.Schema.Get Crater.Schema.Account.EmailSignup

    template.helpers {
        'schema': ->
            signupFormSchema
    }

    Meteor.startup ->
        @AutoForm.hooks {
            presentationEmailSignupForm: Helpers.Client.Form.GetFormHooks {

            }
        }

)(Helpers.Client.TemplatesHelper.Handle('presentation_modal_email_signup'))