# NOTE: AA implicit dependency (needed for `inherited-ressources` to work)
# Ref: https://github.com/activeadmin/inherited_resources/issues/618
class ::ApplicationController < Kit::Auth::DummyAppContainer::Controllers::WebController
end
