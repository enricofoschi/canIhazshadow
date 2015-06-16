Package.describe({
	summary: "Login service for Xing accounts",
	version: "0.0.1"
});

Package.onUse(function(api) {
	api.use('underscore', ['server']);
	api.use('accounts-base', ['client', 'server']);
	// Export Accounts (etc) to packages using this one.
	api.imply('accounts-base', ['client', 'server']);
	api.use('accounts-oauth', ['client', 'server']);
	api.use('xing', ['client', 'server']);

	api.use('http', ['client', 'server']);

	api.addFiles("xing.js");
});