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
    'makePayment': (nonce) ->
        transaction = Meteor.wrapAsync global.braintreeGateway.transaction.sale, global.braintreeGateway.transaction;

        response = transaction {
            amount: 10.00
            paymentMethodNonce: nonce
        }

        response
}