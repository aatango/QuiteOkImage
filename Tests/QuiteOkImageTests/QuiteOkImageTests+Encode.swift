import Foundation
import Testing

@testable import QuiteOkImage

@Suite("QOI_OP_RGB") struct EncodeRgb {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func encodeImageWithOneRgb24Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [0, 42, 66, 255],
        width: 1,
        height: 1,
        channels: .rgba32
      ))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(1).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height
    expectedData.append(contentsOf: [0b11111110, 0, 42, 66])
    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (1 * 4) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithMultipleRgb24Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          0, 42, 66, 255,
          0, 24, 66, 255,
          34, 20, 4, 255,
          6, 66, 166, 255,
        ],
        width: 2,
        height: 2,
        channels: .rgba32
      ))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(2).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(2).asData)  // height
    expectedData.append(contentsOf: [0b11111110, 0, 42, 66])
    expectedData.append(contentsOf: [0b11111110, 0, 24, 66])
    expectedData.append(contentsOf: [0b11111110, 34, 20, 4])
    expectedData.append(contentsOf: [0b11111110, 6, 66, 166])
    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (4 * 4) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}

@Suite("QOI_OP_RGBA") struct EncodeRgbA {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func encodeImageWithOneRgba32Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [0, 42, 66, 0],
        width: 1,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(1).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height
    expectedData.append(contentsOf: [0b11111111, 0, 42, 66, 0])
    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (1 * 5) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithMultipleRgba32Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          0, 42, 66, 0,
          0, 24, 66, 8,
          34, 20, 4, 55,
          6, 66, 166, 255,
        ],
        width: 2,
        height: 2,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(2).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(2).asData)  // height
    expectedData.append(contentsOf: [0b11111111, 0, 42, 66, 0])
    expectedData.append(contentsOf: [0b11111111, 0, 24, 66, 8])
    expectedData.append(contentsOf: [0b11111111, 34, 20, 4, 55])
    expectedData.append(contentsOf: [0b11111111, 6, 66, 166, 255])
    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (4 * 5) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}

@Suite("QOI_OP_INDEX") struct EncodeIndex {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func encodeImageWithIndexToEmptyArray() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [0, 0, 0, 0],
        width: 1,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(1).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height
    expectedData.append(0b00_000000)
    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (1 * 1) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithIndexToIncompleteArray() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          255, 255, 255, 240,
          89, 144, 233, 255,
          255, 255, 255, 240,
          89, 144, 233, 255,
          0, 0, 0, 0,
        ],
        width: 5,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(5).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height

    // Partially fill the running array
    expectedData.append(contentsOf: [0b11111111, 255, 255, 255, 240])  // Index 1
    expectedData.append(contentsOf: [0b11111111, 89, 144, 233, 255])  // Index 47

    // Indexed pixels
    expectedData.append(0b00_000001)
    expectedData.append(0b00_101111)

    // Pixels still zero initialised
    expectedData.append(0b00_000000)

    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (10 + 3) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithIndexToRepopulatedArray() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          13, 17, 32, 217,
          89, 144, 233, 255,
          255, 255, 255, 234,
          89, 144, 233, 255,
          0, 0, 0, 0,
        ],
        width: 5,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData

    expectedData.replaceSubrange(4..<8, with: UInt32(5).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height

    // Partially fill the running array
    expectedData.append(contentsOf: [0b11111111, 13, 17, 32, 217])  // Index 47
    expectedData.append(contentsOf: [0b11111111, 89, 144, 233, 255])  // Also index 47
    expectedData.append(contentsOf: [0b11111111, 255, 255, 255, 234])  // Index 63

    // Indexed pixels
    expectedData.append(0b00_101111)

    // Pixels still zero initialised
    expectedData.append(0b00_000000)

    expectedData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (15 + 2) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}

@Suite("QOI_OP_Diff") struct EncodeDiff {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(2).asData)  // image width in pixels
    self.suiteData.append(UInt32(1).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace

    // Add one custom pixel, so not to compare to default value (0, 0, 0, 255)
    self.suiteData.append(contentsOf: [0b11111111, 0, 1, 42, 166])

    self.suiteData.append(0b01_011011)

    self.suiteData.append(contentsOf: footer)
  }

  @Test func encodeImageWithDifferenceToRgba32Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          0, 1, 42, 166,
          255, 1, 43, 166,
        ],
        width: 2,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    let expectedData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}
@Suite("QOI_OP_LUMA") struct EncodeLuma {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(2).asData)  // image width in pixels
    self.suiteData.append(UInt32(1).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace

    // Add one custom pixel, so not to compare to default value (0, 0, 0, 255)
    self.suiteData.append(contentsOf: [0b11111111, 0, 1, 42, 166])

    self.suiteData.append(contentsOf: [0b10_011011, 0b0000_1111])

    self.suiteData.append(contentsOf: footer)
  }

  @Test func encodeImageWithLumaDifferenceToRgba32Pixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: [
          0, 1, 42, 166,
          243, 252, 44, 166,
        ],
        width: 2,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    let expectedData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 2) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}

@Suite("QOI_OP_RUN") struct EncodeRun {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(2).asData)  // image width in pixels
    self.suiteData.append(UInt32(1).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace

    // Add one custom pixel, so not to compare to default value (0, 0, 0, 255)
    self.suiteData.append(contentsOf: [0b11111111, 0, 1, 42, 166])

    self.suiteData.append(0b11_000000)

    self.suiteData.append(contentsOf: footer)

  }

  @Test func encodeImageWithOneRepeatedPixel() async throws {
    let image = try #require(
      QuiteOkImage(
        data: (0..<2).flatMap { _ in [0, 1, 42, 166] },
        width: 2,
        height: 1,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    let expectedData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    #expect(encodedImage.prefix(4) == magicBytes)
    #expect(encodedImage.suffix(8) == footer)

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithMultipleRepeatedPixels() async throws {
    let image = try #require(
      QuiteOkImage(
        data: (0..<(7 * 6)).flatMap { _ in [0, 1, 42, 166] },
        width: 7,
        height: 6,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData
    expectedData.replaceSubrange(4..<8, with: UInt32(7).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(6).asData)  // height

    let runIndex = 19
    try #require(expectedData[runIndex] == 0b11_000000)
    expectedData[runIndex] = 0b11_101000

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    try #require(encodedImage[14...18] == Data([0b11111111, 0, 1, 42, 166]))

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }

  @Test func encodeImageWithMaximumRepeatedPixels() async throws {
    let image = try #require(
      QuiteOkImage(
        data: (0..<63).flatMap { _ in [0, 1, 42, 166] },
        width: 21,
        height: 3,
        channels: .rgba32))

    let encodedImage = try #require(image.encode())

    var expectedData: Data = suiteData
    expectedData.replaceSubrange(4..<8, with: UInt32(21).asData)  // width
    expectedData.replaceSubrange(8..<12, with: UInt32(3).asData)  // height

    let runIndex = 19
    try #require(expectedData[runIndex] == 0b11_000000)
    expectedData[runIndex] = 0b11_111101

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*footer*/ 8
    try #require(encodedImage.count == expectedDataLength)

    try #require(encodedImage.prefix(4) == magicBytes)
    try #require(encodedImage.suffix(8) == footer)

    try #require(encodedImage[14...18] == Data([0b11111111, 0, 1, 42, 166]))

    #expect(
      encodedImage == expectedData,
      "\([UInt8](encodedImage)) != \([UInt8](expectedData))")
  }
}
