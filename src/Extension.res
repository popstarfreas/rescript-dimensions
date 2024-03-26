type t = {}

module ClientPacketHandler = {
  type t
  type clsOfT<'a, 'b>
  %%raw(`
const ClientPacketHandlerCls = require('dimensions/extension/clientpackethandler').default
function internalMakePacketHandler(
    handlePacket,
) {
    class RClientPacketHandler extends ClientPacketHandlerCls {
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

  let make = (_handlePacket: ('a, 'b, Client.t, RawPacket.t) => bool): clsOfT<'a, 'b> => {
    %raw(`internalMakePacketHandler(_handlePacket)`)
  }
}

module TerrariaServerPacketHandler = {
  type t
  type clsOfT<'a, 'b>
  %%raw(`
const TerrariaServerPacketHandlerCls = require('dimensions/extension/terrariaserverpackethandler').default
function internalMakePacketHandler(
    handlePacket,
) {
    class RTerrariaServerPacketHandler extends TerrariaServerPacketHandlerCls {
        constructor(extension) {
            super()
            this.extension = extension
        }

        handlePacket(terrariaServer, packet) {
          super.handlePacket(terrariaServer, packet)
          return handlePacket(this.extension.self, this.extension, terrariaServer, packet);
        }
    }

    return RTerrariaServerPacketHandler
}
`)

  let make = (_handlePacket: ('a, 'b, TerrariaServer.t, RawPacket.t) => bool): clsOfT<'a, 'b> => {
    %raw(`internalMakePacketHandler(_handlePacket)`)
  }
}

type packetHandler<'a, 'b> = {
  clientHandler?: ClientPacketHandler.clsOfT<'a, 'b>,
  serverHandler?: TerrariaServerPacketHandler.clsOfT<'a, 'b>,
}
%%raw(`
function internalMakeExtension(
    _constructor,
    dispose,
    name,
    version,
    author,
    priorPacketHandlers,
    postPacketHandlers,
) {
    class RExtension {
        constructor(logger) {
            this.name = name
            this.version = version
            this.author = author
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

type clsOfT<'a>
type constructor<'a> = (t, WinstonLogger.t) => 'a
type dispose<'a> = ('a, t) => unit

@val
external internalMakeExtension: (
  ~constructor: constructor<'a>=?,
  ~dispose: dispose<'a>=?,
  ~name: string,
  ~version: string,
  ~author: string,
  ~priorPacketHandler: packetHandler<'a, t>=?,
  ~postPacketHandler: packetHandler<'a, t>=?,
) => clsOfT<'a> = "internalMakeExtension"
let make = internalMakeExtension

@get external name: t => string = "name"
