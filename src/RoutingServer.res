type t = {
  name: string,
  @as("serverIp")
  serverIP: string,
  serverPort: int,
  hidden: bool,
  isVanilla: bool,
}
