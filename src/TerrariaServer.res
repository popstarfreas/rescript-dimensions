type t = RecursiveTypes.terrariaServer
@send external sendDirect: (t, NodeJs.Buffer.t) => unit = "sendDirect"
