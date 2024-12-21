import Cqoi
import Foundation

extension QuiteOkImage {
  public func encode() -> Data? {
    var outCount: Int32 = 0
    var description: qoi_desc = self.description

    return self.data.withUnsafeBytes {
      (rawBufferPointer: UnsafeRawBufferPointer) -> Data? in
      guard let baseAddress = rawBufferPointer.baseAddress else { return nil }

      guard
        let encodedBytesPointer =
          qoi_encode(baseAddress, &description, &outCount)
      else { return nil }

      guard outCount > ( /*header*/14 + /*footer*/ 8)
      else { return nil }

      return Data(bytes: encodedBytesPointer, count: Int(outCount))
    }
  }
}
