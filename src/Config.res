type fakeVersion = {
  enabled: bool,
  terrariaVersin: string,
}

type restApiResponse = {
  name?: string,
  worldName?: string,
  terrariaServerPort?: int,
  hasServerPassword?: bool,
  maxPlayers?: int,
  version?: string,
}

type restApi = {
  enabled: bool,
  port: int,
  response?: restApiResponse,
}

@unboxed
type blockInvis =
  | Bool(bool)
  | Configuration({enabled: bool, servers: array<string>})

type errorPolicy =
  | @as("AllowJoining") AllowJoining
  | @as("DenyJoining") DenyJoining

@tag("enabled")
type blacklist =
  | @as(true)
  Enabled({
      hostname: string,
      path: string,
      port: int,
      apiKey: string,
      errorPolicy: errorPolicy,
    })
  | @as(false) Disabled({})

type logOptions = {
  clientTimeouts: bool,
  clientConnect: bool,
  clientDisconnect: bool,
  clientError: bool,
  checkingClientConnect: bool,
  checkingClientDisconnect: bool,
  checkingClientError: bool,
  checkingClientTimeouts: bool,
  tServerConnect: bool,
  tServerDisconnect: bool,
  tServerError: bool,
  clientBlocked: bool,
  extensionLoad: bool,
  outputToConsole: bool,
  extensionError: bool,
}

type connectionLimit = {
  enabled: bool,
  connectionLimitPerIP: int,
  kickReason: string,
}

type connectionRateLimit = {
  enabled: bool,
  connectionRateLimitPerIP: int,
}

type redisConfig = {
  enabled: bool,
  host: string,
  port: int,
}

type nameChangeMode =
  | @as("legacy") Legacy
  | @as("rewrite") Rewrite

type nameChanges = {
  mode: nameChangeMode,
  exclusions: array<string>,
}

@tag("enabled")
type debuffOnSwitch =
  | @as(true) Enabled({buffTypes: array<int>, debuffTimeInSeconds: int})
  | @as(false) Disabled({})

@tag("enabled")
type disconnectOnKick =
  | @as("always") Always({})
  | @as("never") Never({})
  | @as("onKickReasonPrefix") OnKickReasonPrefix({kickReasonPrefixes: array<string>})

type config = {
  socketTimeout: int,
  socketNoDelay: bool,
  fakeVersion: fakeVersion,
  restApi: restApi,
  blockInvis: blockInvis,
  blacklist: blacklist,
  log: logOptions,
  connectionLimit: connectionLimit,
  connectionRateLimit: connectionRateLimit,
  redis: redisConfig,
  nameChanges?: nameChanges,
  language: Language.languageDefinition,
  debuffOnSwitch: debuffOnSwitch,
  disconnectOnKick: disconnectOnKick,
}
