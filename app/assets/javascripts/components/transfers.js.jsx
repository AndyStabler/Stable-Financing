var Transfer = React.createClass({
  "render": function() {
    var outgoing = this.props.outgoing ? "transfer-out" : "transfer-in";
    return (
      <div className={"transfer " + outgoing }>
        <a className="transfer-destroy" data-remote="true" rel="nofollow" data-method="delete" href={this.props.destroy_link}>
          <i className="glyph-link glyphicon glyphicon-remove"></i>
        </a>
        <h2>{this.props.reference}</h2>
        <p><strong>Date: </strong>{this.props.on}</p>
        <p><strong>Amount: </strong>{"£" + this.props.amount}</p>
        <p><strong>Recurrence: </strong> {this.props.recurrence}</p>
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
            reference={transfer.reference}
            on={new Date(transfer.on).toString()}
            amount={transfer.amount}
            recurrence={transfer.recurrence}
            id={transfer.id}
            destroy_link={"/transfers/" + transfer.id} />
        })}
      </div>
    )
  }
})
