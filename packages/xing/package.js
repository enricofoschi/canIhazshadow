Package.describe({
	summary: "Xing OAuth flow",
	version: '0.0.1'
});

Package.onUse(function(api) {
	api.use('http', ['client', 'server']);
	api.use('templating', 'client');
	api.use('oauth1', ['client', 'server']);
	api.use('oauth', ['client', 'server']);
	api.use('random', 'client');
	api.use('underscore', 'server');
	api.use('service-configuration', ['client', 'server']);

	api.export('Xing');

	api.addFiles(
		['xing_configure.html', 'xing_configure.js'],
		'client');

	api.addFiles('xing_server.js', 'server');
	api.addFiles('xing_client.js', 'client');
});