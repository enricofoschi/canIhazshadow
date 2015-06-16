Xing = {};

var urls = {
    requestToken: "https://api.xing.com/v1/request_token",
    authorize: "https://api.xing.com/v1/authorize",
    accessToken: "https://api.xing.com/v1/access_token",
    authenticate: "https://api.xing.com/v1/authorize"
};

// https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
Xing.whitelistedFields = ['profile_image_url', 'profile_image_url_https', 'lang'];

OAuth.registerService('xing', 1, urls, function(oauthBinding) {
    var identity = oauthBinding.get('https://api.xing.com/v1/users/me').data.users[0];
    var serviceData = _.extend(identity, {
        accessToken: OAuth.sealSecret(oauthBinding.accessToken),
        accessTokenSecret: OAuth.sealSecret(oauthBinding.accessTokenSecret)
    });

    // include helpful fields from twitter
    var fields = _.pick(identity, Xing.whitelistedFields);
    _.extend(serviceData, fields);

    return {
        serviceData: serviceData,
        options: {
            profile: {
                name: identity.display_name
            }
        }
    };
});


Xing.retrieveCredential = function(credentialToken, credentialSecret) {
    return OAuth.retrieveCredential(credentialToken, credentialSecret);
};