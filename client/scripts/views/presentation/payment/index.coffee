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
                        ]
                        callback: (e, r) ->
                            if e
                                Helpers.Client.Notifications.Error 'Oh darn!'
                            else
                                Helpers.Client.Notifications.Success 'Woah buddy!'
                    }
        )

    template.onCustomCreated = =>

        getClientToken initPaymentForm



)(Helpers.Client.TemplatesHelper.Handle('presentation.payment.index'))