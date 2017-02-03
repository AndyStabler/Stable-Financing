#= require init
#= require util
#= require_tree ./templates

#= require support/sinon
#= require support/chai

window.expect = chai.expect

# Show stack trace on failing assertion.
chai.config.includeStack = true;
