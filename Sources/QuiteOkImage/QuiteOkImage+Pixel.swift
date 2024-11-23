public protocol Pixel: Equatable {}

public struct Rgb24: Pixel {
  let red: UInt8
  let green: UInt8
  let blue: UInt8
}

public struct Rgba32: Pixel {
  let red: UInt8
  let green: UInt8
  let blue: UInt8
  let alpha: UInt8
}

extension QuiteOkImage {
  public func at(x: UInt, y: UInt) -> (any Pixel)? {
    guard
      x < self.width,
      y < self.height,
      (x + y * self.width) * self.channels.rawValue < data.count
    else { return nil }

    let pixelNumber = Int((x + y * self.width) * self.channels.rawValue)

    switch self.channels {
      case .rgb24:
        return Rgb24(
          red: self.data[pixelNumber],
          green: self.data[pixelNumber + 1],
          blue: self.data[pixelNumber + 2]
        )
      case .rgba32:
        return Rgba32(
          red: self.data[pixelNumber],
          green: self.data[pixelNumber + 1],
          blue: self.data[pixelNumber + 2],
          alpha: channels == .rgba32 ? self.data[pixelNumber + 3] : 255
        )
    }
  }
}
