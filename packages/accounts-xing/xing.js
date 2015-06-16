Accounts.oauth.registerService('xing');

if (Meteor.isClient) {
    Meteor.loginWithXing = function(options, callback) {
        // support a callback without options
        if (! callback && typeof options === "function") {
            callback = options;
            options = null;
        }

        var credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback);
        Xing.requestCredential(options, credentialRequestCompleteCallback);
    };
} else {
    var autopublishedFields = _.map(
        Xing.whitelistedFields.concat(['id', 'display_name']),
        function (subfield) { return 'services.xing.' + subfield; });

    Accounts.addAutopublishFields({
        forLoggedInUser: autopublishedFields,
        forOtherUsers: autopublishedFields
    });
}