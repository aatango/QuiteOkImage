import Cqoi
import Foundation

extension QuiteOkImage {
  public init?(bytes: Data) {
    var description = qoi_desc(width: 0, height: 0, channels: 0, colorspace: 0)

    let decodedBytes = bytes.withUnsafeBytes {
      (rawBufferPointer: UnsafeRawBufferPointer) -> Data? in
      guard let baseAddress = rawBufferPointer.baseAddress else { return nil }

      guard
        let decodedBytesPointer = qoi_decode(
          baseAddress, Int32(bytes.count), &description, 0)
      else { return nil }

      let pixelCount: UInt32 = description.width * description.height

      return Data(
        bytes: decodedBytesPointer,
        count: Int(pixelCount) * Int(description.channels))
    }

    guard description.width > 0 else { return nil }
    guard description.height > 0 else { return nil }

    guard description.channels == 3 || description.channels == 4
    else { return nil }

    guard decodedBytes != nil else { return nil }

    self.data = [UInt8](decodedBytes!)
    self.width = UInt(description.width)
    self.height = UInt(description.height)
    self.channels = Channels(rawValue: UInt(description.channels))!
  }
}
