type t = RecursiveTypes.client

@send external sendChatMessage: (t, string, ~color: string=?) => unit = "sendChatMessage"
