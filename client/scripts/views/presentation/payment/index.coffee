((template) =>

    getClientToken = (callback) =>
        Helpers.Client.MeteorHelper.CallMethod {
            method: 'getClientToken'
            params: []
            callback: (e, r) =>
                if e
                    Helpers.Client.Notifications.Error 'Braintree.... that hurts! Don\'t leave me in the BattleHack please!'
                else
                    callback r
        }

    initPaymentForm = (clientToken) =>
        braintree.setup clientToken, "dropin", (
            container: "payment-form"
            CVV: true
            onPaymentMethodReceived: (response) ->
                if response
                    Helpers.Client.MeteorHelper.CallMethod {
                        method: 'makePayment'
                        params: [
                            response.nonce
                            template.currentInstance.data.shadowMaster.profile.shadow_for_good.bid
                            template.currentInstance.data.shadowMaster._id
                        ]
                        callback: (e, r) ->
                            if e
                                Helpers.Client.Notifications.Error 'Oh darn!'
                            else
                                Helpers.Client.Notifications.Success 'Well done! Now let the shadowing begin! Your master will soon get in touch with you!'
                    }
        )

    template.onCustomCreated = =>

        getClientToken initPaymentForm

    template.helpers {
        'amount': ->
            @shadowMaster.profile.shadow_for_good.bid
    }



)(Helpers.Client.TemplatesHelper.Handle('presentation.payment.index'))