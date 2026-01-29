type t = RecursiveTypes.client

@send external sendChatMessage: (t, string, ~color: string=?) => unit = "sendChatMessage"
@send external sendDirect: (t, NodeJs.Buffer.t) => unit = "sendDirect"
