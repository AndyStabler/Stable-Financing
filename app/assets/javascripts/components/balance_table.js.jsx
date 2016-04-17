Date.prototype.toString = function() {
  return this.getDate() + "-" + (this.getMonth() + 1) + "-" + this.getFullYear()
}

var TableHeader = React.createClass({
  "render": function() {
    return (
      <tr>
        <th>Date</th>
        <th>Balance</th>
      </tr>
    )
  }
});

var TableRow = React.createClass({
  "render": function() {
    // debugger
    return (
      <tr className="balance-table-row" data-date-id={this.props.date}>
        <td>{this.props.date.toString()}</td>
        <td>{"£" + this.props.balance}</td>
      </tr>
    )
  }
});

var BalanceTable = React.createClass({
  "render": function() {
    return (
      <table>
        <tbody>
          <TableHeader />
          {this.props.balanceData.balanceLog.map(function(log){
            return <TableRow key={log.dateId} date={log.date} balance={log.balance} />
          })}
          {this.props.balanceData.balanceForecast.map(function(forecast){
            return <TableRow key={forecast.dateId} date={forecast.date} balance={forecast.balance} />
          })}
        </tbody>
      </table>
    )
  }
});
