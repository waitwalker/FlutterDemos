/// A message that was sent by JavaScript code running in a [WebView].

class MTTJavascriptMessage {
  /// Constructs a JavaScript message object.
  ///
  /// The `message` parameter must not be null.
  const MTTJavascriptMessage(this.message) : assert(message != null);

  /// The contents of the message that was sent by the JavaScript code.
  final String message;
}
