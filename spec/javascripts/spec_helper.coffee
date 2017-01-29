#= require init
#= require util
#= require_tree ./templates

# set the Mocha test interface
# see http://mochajs.org/#interfaces
mocha.ui('bdd');

# Show stack trace on failing assertion.
chai.config.includeStack = true;
