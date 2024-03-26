type t = {
  command: ClientCommandHandler.t,
  clientPacketHandler: ClientPacketHandler.t,
  terrariaServerPacketHandler: TerrariaServerPacketHandler.t,
  extensions: Dict.t<Extension.t>,
}
