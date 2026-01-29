type t = {
  id: string,
  socket: NodeJs.Net.Socket.t,
  server: RoutingServer.t,
  serversDetails: Dict.t<ServersDetails.t>,
  globalHandlers: unknown,
  servers: Dict.t<RoutingServer.t>,
  options: Config.config,
  globalTracking: GlobalTracking.t,
  logging: WinstonLogger.t,
}
