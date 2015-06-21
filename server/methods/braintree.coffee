Meteor.startup ->
    braintree = Meteor.npmRequire('braintree');

    options = {
        environment: braintree.Environment.Sandbox,
        publicKey: Meteor.settings.braintree.publicKey,
        privateKey: Meteor.settings.braintree.privateKey,
        merchantId: Meteor.settings.braintree.merchantId
    }

    global.braintreeGateway = braintree.connect options


Meteor.methods {
    'getClientToken': (clientId) ->
        generateToken = Meteor.wrapAsync global.braintreeGateway.clientToken.generate, global.braintreeGateway.clientToken
        response = generateToken {}
        return response.clientToken
    'makePayment': (nonce, amount, auctionId) ->
        transaction = Meteor.wrapAsync global.braintreeGateway.transaction.sale, global.braintreeGateway.transaction;

        response = transaction {
            amount: 10.00
            paymentMethodNonce: nonce
        }

        auction = new MeteorUser auctionId

        auction.update {
            $set:
                'profile.shadow_for_good.paid': true
        }

        currentUser = new MeteorUser Meteor.user()

        Helpers.Server.ShadowForGood.Email.Send {
            template: 'paid'
            subject: 'Time To Be The Shadow Master'
            data: {
                amount: auction.shadow_for_good.bid
                email: currentUser.getEmail()
                phone: currentUser.profile.phone
            }
            to: auction.getEmail()
            from: 'noreply@shadowforgood.de'
        }

        response
}