import Foundation

extension QuiteOkImage {
  public init?(fromFile path: URL) {
    guard let bytes = try? Data(contentsOf: path) else { return nil }

    self.init(bytes: bytes)
  }
}
