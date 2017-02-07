#= require spec_helper
#= require models/balance

describe 'Balance', ->
  it 'constructs the object when the arguments are strings', ->
    date = "2016-12-04T00:00:00.000Z"
    balance = new StableFinancing.Models.Balance(date, "50.20")
    expect(balance.on.getTime()).to.equal(new Date(date).getTime())
    expect(balance.value).to.equal(50.20)

  it 'constructs the object', ->
    date = new Date("2016-12-04T00:00:00.000Z")
    balance = new StableFinancing.Models.Balance(date, 50.20)
    expect(balance.on.getTime()).to.equal(date.getTime())
    expect(balance.value).to.equal(50.20)
