Kit::Auth::Log.log(msg: 'seeding defaults `oauth_applications`', flags: [:debug, :db, :seed])

list = [
  {
    uid:          'api',
    name:         'API',
    scopes:       '',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
  },
  {
    uid:          'webapp',
    name:         'Webapp',
    scopes:       '',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
  },
]

list.each do |el|
  #Kit::Auth::Models::Write::OauthApplication
  ::Doorkeeper::Application
    .create_with({
      name:         el[:name],
      scopes:       el[:scopes],
      redirect_uri: el[:redirect_uri],
    })
    .find_or_create_by!({
      uid: el[:uid],
    })
rescue StandardError => e
  puts e
  puts e.backtrace.first
end
