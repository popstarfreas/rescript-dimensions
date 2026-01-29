type rec client = {
  @as("ID")
  id: string,
  options: Config.config,
  servers: Dict.t<RoutingServer.t>,
  socket: NodeJs.Net.Socket.t,
  ip: string,
  player: Player.t,
  server: terrariaServer,
  connected: bool,
  state: ClientState.t,
  ingame: bool,
  @as("UUID")
  uuid: string,
  waitingCharacterRestore: bool,
  wasKicked: bool,
  routingInformation: Null.t<RoutingInformation.t>,
  countIncremented: bool,
  serversDetails: Dict.t<ServersDetails.t>,
  preventSpawnOnJoin: bool,
  packetQueue: array<NodeJs.Buffer.t>,
  logging: WinstonLogger.t,
  version: string,
}
and terrariaServer = {name: string, @as("isSSC") isSsc: bool, client: client}
