#= require spec_helper
#= require util

describe 'Date', ->
  describe '#toString', ->
    it 'is the correct format', ->
      dateString = new Date(2017, 1, 16).toString()
      expect(dateString).to.equal('16-1-2017')

  describe '.parseRailsDate', ->
    it 'can parse valid date', ->
      dateString = '2017-01-15 20:57:13 UTC'
      expectedDate = new Date(Date.UTC(2017, 1, 15, 20, 57, 13)).getTime()
      expect(Date.parseRailsDate(dateString).getTime()).to.equal(expectedDate)

    it 'is NaN when date is not valid', ->
      dateString = 'cheese 2k17'
      expect(Date.parseRailsDate(dateString)).to.be.NaN
