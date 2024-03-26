type t

type logLevel = [#debug | #info | #warn | #error]
@send external log: (t, logLevel, string) => unit = "log"
@send external info: (t, string) => unit = "info"
@send external warn: (t, string) => unit = "warn"
@send external error: (t, string) => unit = "error"
