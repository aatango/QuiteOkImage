public enum Channels: UInt {
  case rgb24 = 3
  case rgba32 = 4
}

public enum Colorspace {
  case sRGB
  case linear
}

public struct QuiteOkImage {
  let data: [UInt8]
  let width: UInt
  let height: UInt
  let channels: Channels
  let colorspace: Colorspace = .linear

  public init?(data: [UInt8], width: UInt, height: UInt, channels: Channels) {
    guard
      width > 0,
      height > 0,
      data.count == width * height * channels.rawValue
    else { return nil }

    self.channels = channels
    self.data = data
    self.height = height
    self.width = width
  }
}
