# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{root@104.131.32.15}
role :web, %w{root@104.131.32.15}
role :db,  %w{root@104.131.32.15}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '104.131.32.15', user: 'root', roles: %w{web app}, my_property: :my_value

set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    password: 'HTN2014rocks',
    user: 'root',
}