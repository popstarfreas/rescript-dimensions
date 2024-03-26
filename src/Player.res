type position = {
  x: float,
  y: float,
}

type color = {
  @as("R")
  r: int,
  @as("G")
  g: int,
  @as("B")
  b: int,
}

type difficulty = TerrariaPacket.Packet.PlayerInfo.difficulty
type mode = TerrariaPacket.Packet.PlayerInfo.mode

type t = {
  id: int,
  name: string,
  inventory: array<Nullable.t<Item.t>>,
  life: int,
  mana: int,
  allowedNameChange: bool,
  allowedCharacterChange: bool,
  allowedLifeChange: bool,
  allowedManaChange: bool,
  position: position,
  skinVariant: int,
  hair: int,
  hairDye: int,
  hideVisuals: int,
  hideVisuals2: int,
  hideMisc: int,
  hairColor: color,
  skinColor: color,
  eyeColor: color,
  shirtColor: color,
  underShirtColor: color,
  pantsColor: color,
  shoeColor: color,
  extraAccessory: bool,
  usingBiomeTorches: bool,
  unlockedBiomeTorches: bool,
  happyFunTorchTime: bool,
  difficulty: difficulty,
  mode: mode,
}
