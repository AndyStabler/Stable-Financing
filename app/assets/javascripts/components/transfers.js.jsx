var Transfer = React.createClass({
  "render": function() {
    var outgoing = this.props.outgoing ? "out" : "in";
    return (
      <div className={"transfer " + outgoing }>
        <h2>{this.props.reference}</h2>
        <p><strong>Date: </strong>{this.props.on}</p>
        <p><strong>Amount: </strong>{"£" + this.props.amount}</p>
        <p><strong>Recurrence: </strong> {this.props.recurrence}</p>
        <a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href={"/transfer_monthly/" + this.props.id}>Destroy</a>
      </div>
    )
  }
});

var Transfers = React.createClass({
  "render": function() {
    return (
      <div>
        {this.props.transfers.map(function (transfer) {
          return <Transfer
            key={transfer.id}
            outgoing={transfer.outgoing}
            on={transfer.on}
            amount={transfer.amount}
            recurrence={transfer.recurrence}
            id={transfer.id} />
        })}
      </div>
    )
  }
})
