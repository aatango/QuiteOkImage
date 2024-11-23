import Testing

@testable import QuiteOkImage

@Test func failToRetrievePixelFromOutsideImageBoundary() async throws {
  let image = try #require(
    QuiteOkImage(data: [0, 0, 0], width: 1, height: 1, channels: .rgb24)
  )

  #expect(image.at(x: 1, y: 0) == nil)
  #expect(image.at(x: 0, y: 1) == nil)
}

@Test func retrieveValidPixelFromRgb24Image() async throws {
  let image = try #require(
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

  #expect(
    image.at(x: 0, y: 0) == Rgba32(red: 0, green: 1, blue: 1, alpha: 255))
  #expect(
    image.at(x: 1, y: 0) == Rgba32(red: 2, green: 3, blue: 5, alpha: 255))
  #expect(
    image.at(x: 0, y: 1) == Rgba32(red: 8, green: 13, blue: 21, alpha: 255))
  #expect(
    image.at(x: 1, y: 1) == Rgba32(red: 34, green: 55, blue: 89, alpha: 255))
}

@Test func retrieveValidPixelFromRgba32Image() async throws {
  let image = try #require(
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

  #expect(
    image.at(x: 0, y: 0) == Rgba32(red: 0, green: 1, blue: 1, alpha: 0))
  #expect(
    image.at(x: 1, y: 0) == Rgba32(red: 2, green: 3, blue: 5, alpha: 63))
  #expect(
    image.at(x: 0, y: 1) == Rgba32(red: 8, green: 13, blue: 21, alpha: 172))
  #expect(
    image.at(x: 1, y: 1) == Rgba32(red: 34, green: 55, blue: 89, alpha: 255))
}
