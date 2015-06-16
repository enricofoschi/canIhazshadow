Template.configureLoginServiceDialogForXing.helpers({
    siteUrl: function () {
        // Twitter doesn't recognize localhost as a domain name
        return Meteor.absoluteUrl({replaceLocalhost: true});
    }
});

Template.configureLoginServiceDialogForXing.fields = function () {
    return [
        {property: 'consumerKey', label: 'API key'},
        {property: 'secret', label: 'API secret'}
    ];
};