type t = {}
type packetHandlerResult =
  | @as(false) AllowPacket
  | @as(true) BlockPacket

type clientPacketHandlerCls
@module("dimensions/extension/clientpackethandler") @val
external clientPacketHandlerCls: clientPacketHandlerCls = "default"

type terrariaServerPacketHandlerCls
@module("dimensions/extension/terrariaserverpackethandler") @val
external terrariaServerPacketHandlerCls: terrariaServerPacketHandlerCls = "default"

module ClientPacketHandler = {
  type t
  type clsOfT<'a, 'b>
  type handlePacket<'a, 'b> = ('a, 'b, Client.t, RawPacket.t) => packetHandlerResult
  let internalMakePacketHandler: (
    handlePacket<'a, 'b>,
    clientPacketHandlerCls,
  ) => clsOfT<'a, 'b> = %raw(`
function internalMakePacketHandler(
    handlePacket,
    clientPacketHandlerCls,
) {
    class RClientPacketHandler extends clientPacketHandlerCls {
        constructor(extension) {
            super()
            this.extension = extension
        }

        handlePacket(client, packet) {
          super.handlePacket(client, packet)
            return handlePacket(this.extension.self, this.extension, client, packet);
        }
    }

    return RClientPacketHandler
}
`)

  let make = (handlePacket: handlePacket<'a, 'b>): clsOfT<'a, 'b> => {
    internalMakePacketHandler(handlePacket, clientPacketHandlerCls)
  }
}

module PacketSource = {
  type t =
    | @as(0) TerrariaServer
    | @as(1) Dimensions
}

module TerrariaServerPacketHandler = {
  type t
  type clsOfT<'a, 'b>
  type handlePacket<'a, 'b> = ('a, 'b, TerrariaServer.t, RawPacket.t, PacketSource.t) => packetHandlerResult
  let internalMakePacketHandler: (
    handlePacket<'a, 'b>,
    terrariaServerPacketHandlerCls,
  ) => clsOfT<'a, 'b> = %raw(`
function internalMakePacketHandler(
    handlePacket,
    terrariaServerPacketHandlerCls,
) {
    class RTerrariaServerPacketHandler extends terrariaServerPacketHandlerCls {
        constructor(extension) {
            super()
            this.extension = extension
        }

        handlePacket(terrariaServer, packet, source) {
          super.handlePacket(terrariaServer, packet, source)
          return handlePacket(this.extension.self, this.extension, terrariaServer, packet, source);
        }
    }

    return RTerrariaServerPacketHandler
}
`)

  let make = (handlePacket: handlePacket<'a, 'b>): clsOfT<'a, 'b> => {
    internalMakePacketHandler(handlePacket, terrariaServerPacketHandlerCls)
  }
}

type packetHandler<'a, 'b> = {
  clientHandler?: ClientPacketHandler.clsOfT<'a, 'b>,
  serverHandler?: TerrariaServerPacketHandler.clsOfT<'a, 'b>,
}

type clsOfT<'a>
type constructor<'a> = (t, WinstonLogger.t) => 'a
type dispose<'a> = ('a, t) => unit
type clientErrorHandler<'a> = ('a, t, Client.t, JsError.t) => bool
type serverErrorHandler<'a> = ('a, t, TerrariaServer.t, JsError.t) => bool
type socketConnectPreHandler<'a> = ('a, t, NodeJs.Net.Socket.t) => Promise.t<bool>
type socketConnectPostHandler<'a> = ('a, t, NodeJs.Net.Socket.t) => unit
type clientFullyConnectedHandler<'a> = ('a, t, Client.t) => unit
type sendPacketToClientEvent<'a> = ('a, t, Client.t, NodeJs.Buffer.t) => unit
type sendPacketToServerEvent<'a> = ('a, t, TerrariaServer.t, NodeJs.Buffer.t) => unit
type clientConnectEvent<'a> = ('a, t, Client.t) => unit
type clientDisconnectEvent<'a> = ('a, t, Client.t) => unit
type socketClosePreHandler<'a> = ('a, t, NodeJs.Net.Socket.t, Client.t) => bool
type socketClosePostHandler<'a> = ('a, t, NodeJs.Net.Socket.t, Client.t) => unit
type serverDisconnectHandler<'a> = ('a, t, TerrariaServer.t) => bool
type blacklistCheckState =
  | @as("AssignedClientId") AssignedClientId
  | @as("SentPlayerInfo") SentPlayerInfo
  | @as("SentUuid") SentUuid
type blacklistCheckContext = {
  socket: NodeJs.Net.Socket.t,
  clientArgs: ClientArgs.t,
  state: blacklistCheckState,
}
type blacklistCheckPacketPreHandler<'a> = ('a, t, blacklistCheckContext, RawPacket.t) => bool
type blacklistCheckPacketPostHandler<'a> = ('a, t, blacklistCheckContext, RawPacket.t) => bool
type rawSocketWriteReason =
  | @as("blacklistCheck") BlacklistCheck
  | @as("connectionLimitExceeded") ConnectionLimitExceeded
  | @as("blacklistCheckClientSetup") BlacklistCheckClientSetup
  | @as("other") Other
type rawSocketWriteContext = {
  socket: NodeJs.Net.Socket.t,
  remoteAddress?: string,
  reason: rawSocketWriteReason,
  clientArgs?: ClientArgs.t,
}
type rawSocketWritePacket = {mutable packet: NodeJs.Buffer.t}
type rawSocketWritePreHandler<'a> = ('a, t, rawSocketWriteContext, rawSocketWritePacket) => bool
type rawSocketWritePostHandler<'a> = ('a, t, rawSocketWriteContext, rawSocketWritePacket) => unit
type unloadEvent<'a, 'storage> = ('a, t) => 'storage
type loadEvent<'a, 'storage> = ('a, t, 'storage) => unit
type reloadEvent<'a> = ('a, t) => unit
type makeExtension<'a, 'storage> = (
  ~constructor: constructor<'a>=?,
  ~dispose: dispose<'a>=?,
  ~name: string,
  ~version: string,
  ~author: string,
  ~reloadable: bool=?,
  ~reloadName: string=?,
  ~priorPacketHandler: packetHandler<'a, t>=?,
  ~postPacketHandler: packetHandler<'a, t>=?,
  ~clientConnectEvent: clientConnectEvent<'a>=?,
  ~clientDisconnectEvent: clientDisconnectEvent<'a>=?,
  ~unloadEvent: unloadEvent<'a, 'storage>=?,
  ~loadEvent: loadEvent<'a, 'storage>=?,
  ~reloadEvent: reloadEvent<'a>=?,
  ~clientErrorHandler: clientErrorHandler<'a>=?,
  ~serverErrorHandler: serverErrorHandler<'a>=?,
  ~socketConnectPreHandler: socketConnectPreHandler<'a>=?,
  ~socketConnectPostHandler: socketConnectPostHandler<'a>=?,
  ~clientFullyConnectedHandler: clientFullyConnectedHandler<'a>=?,
  ~sendPacketToClientEvent: sendPacketToClientEvent<'a>=?,
  ~sendPacketToServerEvent: sendPacketToServerEvent<'a>=?,
  ~socketClosePreHandler: socketClosePreHandler<'a>=?,
  ~socketClosePostHandler: socketClosePostHandler<'a>=?,
  ~serverDisconnectPreHandler: serverDisconnectHandler<'a>=?,
  ~serverDisconnectHandler: serverDisconnectHandler<'a>=?,
  ~blacklistCheckPacketPreHandler: blacklistCheckPacketPreHandler<'a>=?,
  ~blacklistCheckPacketPostHandler: blacklistCheckPacketPostHandler<'a>=?,
  ~rawSocketWritePreHandler: rawSocketWritePreHandler<'a>=?,
  ~rawSocketWritePostHandler: rawSocketWritePostHandler<'a>=?,
) => clsOfT<'a>
let make: makeExtension<'a, 'storage> = %raw(`
function internalMakeExtension(
    _constructor,
    dispose,
    name,
    version,
    author,
    reloadable,
    reloadName,
    priorPacketHandlers,
    postPacketHandlers,
    clientConnectEvent,
    clientDisconnectEvent,
    unloadEvent,
    loadEvent,
    reloadEvent,
    clientErrorHandler,
    serverErrorHandler,
    socketConnectPreHandler,
    socketConnectPostHandler,
    clientFullyConnectedHandler,
    sendPacketToClientEvent,
    sendPacketToServerEvent,
    socketClosePreHandler,
    socketClosePostHandler,
    serverDisconnectPreHandler,
    serverDisconnectHandler,
    blacklistCheckPacketPreHandler,
    blacklistCheckPacketPostHandler,
    rawSocketWritePreHandler,
    rawSocketWritePostHandler,
) {
    class RExtension {
        constructor(logger) {
            this.name = name
            this.version = version
            this.author = author
            this.reloadable = reloadable
            this.reloadName = reloadName
            if (_constructor) {
                this.self = _constructor(this, logger)
            }
            if (priorPacketHandlers) {
                this.priorPacketHandlers = {
                    clientHandler: priorPacketHandlers.clientHandler ? new priorPacketHandlers.clientHandler(this) : undefined,
                    serverHandler: priorPacketHandlers.serverHandler ? new priorPacketHandlers.serverHandler(this) : undefined,
                }
            }

            if (postPacketHandlers) {
                this.postPacketHandlers = {
                    clientHandler: postPacketHandlers.clientHandler ? new postPacketHandlers.clientHandler(this) : undefined,
                    serverHandler: postPacketHandlers.serverHandler ? new postPacketHandlers.serverHandler(this) : undefined,
                }
            }
        }

        clientConnectEvent(client) {
            if (clientConnectEvent) {
                clientConnectEvent(this.self, this, client)
            }
        }
        clientDisconnectEvent(client) {
            if (clientDisconnectEvent) {
                clientDisconnectEvent(this.self, this, client)
            }
        }

        unload() {
            if (unloadEvent) {
                unloadEvent(this.self, this)
            }
        }

        load(storage) {
            if (loadEvent) {
                loadEvent(this.self, this, storage)
            }
        }

        reload() {
            if (reloadEvent) {
                reloadEvent(this.self, this)
            }
        }

        clientErrorHandler(client, error) {
            if (clientErrorHandler) {
                return clientErrorHandler(this.self, this, client, error)
            }
            return false
        }

        serverErrorHandler(terrariaServer, error) {
            if (serverErrorHandler) {
                return serverErrorHandler(this.self, this, terrariaServer, error)
            }
            return false
        }

        socketConnectPreHandler(socket) {
            if (socketConnectPreHandler) {
                return socketConnectPreHandler(this.self, this, socket)
            }
            return Promise.resolve(false)
        }

        socketConnectPostHandler(socket) {
            if (socketConnectPostHandler) {
                socketConnectPostHandler(this.self, this, socket)
            }
        }
        
        clientFullyConnectedHandler(client) {
            if (clientFullyConnectedHandler) {
                clientFullyConnectedHandler(this.self, this, client)
            }
        }

        sendPacketToClientEvent(client, packet) {
            if (sendPacketToClientEvent) {
                return sendPacketToClientEvent(this.self, this, client, packet)
            }
            return false
        }

        sendPacketToServerEvent(terrariaServer, packet) {
            if (sendPacketToServerEvent) {
                return sendPacketToServerEvent(this.self, this, terrariaServer, packet)
            }
            return false
        }

        socketClosePreHandler(socket, client) {
            if (socketClosePreHandler) {
                return socketClosePreHandler(this.self, this, socket, client)
            }
            return false
        }

        socketClosePostHandler(socket, client) {
            if (socketClosePostHandler) {
                socketClosePostHandler(this.self, this, socket, client)
            }
        }

        serverDisconnectPreHandler(terrariaServer) {
            if (serverDisconnectPreHandler) {
                return serverDisconnectPreHandler(this.self, this, terrariaServer)
            }
            return false
        }

        serverDisconnectHandler(terrariaServer) {
            if (serverDisconnectHandler) {
                return serverDisconnectHandler(this.self, this, terrariaServer)
            }
            return false
        }

        blacklistCheckPacketPreHandler(context, packet) {
            if (blacklistCheckPacketPreHandler) {
                return blacklistCheckPacketPreHandler(this.self, this, context, packet)
            }
            return false
        }

        blacklistCheckPacketPostHandler(context, packet) {
            if (blacklistCheckPacketPostHandler) {
                return blacklistCheckPacketPostHandler(this.self, this, context, packet)
            }
            return false
        }

        rawSocketWritePreHandler(context, packet) {
            if (rawSocketWritePreHandler) {
                return rawSocketWritePreHandler(this.self, this, context, packet)
            }
            return false
        }

        rawSocketWritePostHandler(context, packet) {
            if (rawSocketWritePostHandler) {
                rawSocketWritePostHandler(this.self, this, context, packet)
            }
        }

        dispose() {
            super.dispose()
            if (dispose) {
                dispose(this.self, this)
            }
        }
    }

    return RExtension
}
`)

@get external name: t => string = "name"
