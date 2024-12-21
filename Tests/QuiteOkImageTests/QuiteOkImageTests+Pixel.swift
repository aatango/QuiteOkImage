import Testing

@testable import QuiteOkImage

@Test func failToRetrievePixelFromOutsideImageBoundary() async throws {
  let image = try #require(
    QuiteOkImage(data: [0, 0, 0], width: 1, height: 1, channels: .rgb24)
  )

  #expect(image.at(x: 1, y: 0) == nil)
  #expect(image.at(x: 0, y: 1) == nil)
}

@Suite("Rgb24 Image") struct Rgb24Image {
  let image: QuiteOkImage

  private init() async throws {
    self.image = try #require(
      QuiteOkImage(
        data: [
          0, 1, 1,
          2, 3, 5,
          8, 13, 21,
          34, 55, 89,
        ],
        width: 2,
        height: 2,
        channels: .rgb24
      )
    )
  }

  @Test func failToRetrieveRgba32PixelFromRgb24Image() async throws {
    #expect(image.at(x: 0, y: 0) as? Rgba32 == nil)
  }

  @Test func retrieveValidPixelFromRgb24Image() async throws {
    let pixel00 = try #require(image.at(x: 0, y: 0) as? Rgb24)
    let pixel10 = try #require(image.at(x: 1, y: 0) as? Rgb24)
    let pixel01 = try #require(image.at(x: 0, y: 1) as? Rgb24)
    let pixel11 = try #require(image.at(x: 1, y: 1) as? Rgb24)

    #expect(pixel00 == Rgb24(red: 0, green: 1, blue: 1))
    #expect(pixel10 == Rgb24(red: 2, green: 3, blue: 5))
    #expect(pixel01 == Rgb24(red: 8, green: 13, blue: 21))
    #expect(pixel11 == Rgb24(red: 34, green: 55, blue: 89))
  }
}

@Suite("Rgba32 Image") struct Rgba32Image {
  let image: QuiteOkImage

  private init() async throws {
    self.image = try #require(
      QuiteOkImage(
        data: [
          0, 1, 1, 0,
          2, 3, 5, 63,
          8, 13, 21, 172,
          34, 55, 89, 255,
        ],
        width: 2,
        height: 2,
        channels: .rgba32
      )
    )
  }

  @Test func failToRetrieveRgb24PixelFromRgba32Image() async throws {
    #expect(image.at(x: 0, y: 0) as? Rgb24 == nil)
  }

  @Test func retrieveValidPixelFromRgba32Image() async throws {
    let pixel00 = try #require(image.at(x: 0, y: 0) as? Rgba32)
    let pixel10 = try #require(image.at(x: 1, y: 0) as? Rgba32)
    let pixel01 = try #require(image.at(x: 0, y: 1) as? Rgba32)
    let pixel11 = try #require(image.at(x: 1, y: 1) as? Rgba32)

    #expect(pixel00 == Rgba32(red: 0, green: 1, blue: 1, alpha: 0))
    #expect(pixel10 == Rgba32(red: 2, green: 3, blue: 5, alpha: 63))
    #expect(pixel01 == Rgba32(red: 8, green: 13, blue: 21, alpha: 172))
    #expect(pixel11 == Rgba32(red: 34, green: 55, blue: 89, alpha: 255))
  }
}
