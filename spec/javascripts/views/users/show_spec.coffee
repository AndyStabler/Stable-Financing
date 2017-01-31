#= require spec_helper
# require views/users/show

describe 'Users.Show', ->

  # beforeEach ->
  #   $('body').html(JST['templates/views/users/show']());
  #   sinon.stub $, 'getJSON', (options) ->
  #     deferred = $.Deferred()

  #     deferred.done(options.success) if options.success
  #     deferred.fail(options.fail) if options.fail

  #     deferred.success = deferred.done
  #     deferred.error = deferred.fail

  #     return deferred

  # afterEach ->
  #   $.getJSON.restore();

  describe '.fetchTransfers', ->
    it 'correctly handles success', ->
      success = () -> "Success!"
      # StableFinancing.Views.Users.Show.fetchTransfers(sucess: sucess).resolve()
      expect(true).to.be.true
    it 'correctly handles failure', ->
      expect(false).to.be.true

  describe '.fetchBalances', ->
    it 'correctly handles success', ->
      expect(false).to.be.true
    it 'correctly handles failure', ->
      expect(false).to.be.true
