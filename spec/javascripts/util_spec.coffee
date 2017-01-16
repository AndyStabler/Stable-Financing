#= require spec_helper
#= require util

describe 'Date', ->
  describe '#toString', ->
    it 'is the correct format', ->
      dateString = new Date(2017, 1, 16).toString()
      expect(dateString).to.equal('16-1-2017')
