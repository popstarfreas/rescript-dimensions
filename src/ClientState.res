type t =
  | @as(0) FreshConnection
  | @as(1) FinishinedSendingInventory
  | @as(2) ConnectionSwitchEstablished
  | @as(3) FinalisingSwitch
  | @as(4) FullyConnected
  | @as(5) Disconnected // From a Terraria Server
