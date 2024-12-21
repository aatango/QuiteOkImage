import Foundation
import Testing

@testable import QuiteOkImage

extension UInt32 {
  var asData: Data {
    let data: [UInt8] = [
      UInt8((self >> 24) & 0xFF),
      UInt8((self >> 16) & 0xFF),
      UInt8((self >> 8) & 0xFF),
      UInt8(self & 0xFF),
    ]

    return Data(data)
  }
}

let magicBytes = Data([0x71, 0x6F, 0x69, 0x66])  // Magic bytes "qoif"
let footer = Data([0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1])  // Byte stream end

@Test func failToDecodeEmptyData() async throws {
  let data = Data()

  try #require(data.count == 0)

  #expect(QuiteOkImage(bytes: data) == nil)
}

@Test func failToDecodeImageWithZeroPixels() async throws {
  var testData: Data

  testData = Data()

  testData.append(contentsOf: magicBytes)
  testData.append(UInt32(0).asData)  // image width in pixels
  testData.append(UInt32(0).asData)  // image height in pixels
  testData.append(4)  // Channels.rgba32
  testData.append(1)  // all channels have linear colorspace
  testData.append(contentsOf: footer)

  let expectedDataLength: UInt =
    /*header*/ 14 + /*pixels*/ 0 + /*end marker*/ 8

  try #require(testData.count == expectedDataLength)

  #expect(QuiteOkImage(bytes: testData) == nil)
}

@Suite("QOI_OP_RGB") struct DecodeRgb {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func decodeImageWithOneRgb24Pixel() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(1).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height

    testData.append(contentsOf: [0b11111110, 0, 1, 1])

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (1 * 4) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 1)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 4)

    #expect(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 1, alpha: 255))
  }

  @Test func decodeImageWithMultipleRgb24Pixels() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(2).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(2).asData)  // height

    testData.append(contentsOf: [0b11111110, 0, 1, 1])
    testData.append(contentsOf: [0b11111110, 2, 3, 5])
    testData.append(contentsOf: [0b11111110, 8, 13, 21])
    testData.append(contentsOf: [0b11111110, 34, 55, 89])

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (4 * 4) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 2)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 16)

    #expect(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 1, alpha: 255))
    #expect(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 2, green: 3, blue: 5, alpha: 255))
    #expect(
      image.at(x: 0, y: 1) as? Rgba32
        == Rgba32(red: 8, green: 13, blue: 21, alpha: 255))
    #expect(
      image.at(x: 1, y: 1) as? Rgba32
        == Rgba32(red: 34, green: 55, blue: 89, alpha: 255))
  }
}

@Suite("QOI_OP_RGBA") struct DecodeRgbA {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func decodeImageWithOneRgba32Pixel() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(1).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height

    testData.append(contentsOf: [0b11111111, 0, 1, 1, 0])

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (1 * 5) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 1)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 4)

    #expect(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 1, alpha: 0))
  }

  @Test func decodeImageWithMultipleRgba32Pixels() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(2).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(2).asData)  // height

    testData.append(contentsOf: [0b11111111, 0, 1, 1, 0])
    testData.append(contentsOf: [0b11111111, 2, 3, 5, 8])
    testData.append(contentsOf: [0b11111111, 13, 21, 34, 55])
    testData.append(contentsOf: [0b11111111, 89, 144, 233, 255])

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (4 * 5) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 2)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 16)

    #expect(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 1, alpha: 0))
    #expect(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 2, green: 3, blue: 5, alpha: 8))
    #expect(
      image.at(x: 0, y: 1) as? Rgba32
        == Rgba32(red: 13, green: 21, blue: 34, alpha: 55))
    #expect(
      image.at(x: 1, y: 1) as? Rgba32
        == Rgba32(red: 89, green: 144, blue: 233, alpha: 255))
  }
}

@Suite("QOI_OP_INDEX") struct DecodeIndex {
  var suiteData: Data

  private init() async {
    self.suiteData = Data()

    self.suiteData.append(contentsOf: magicBytes)
    self.suiteData.append(UInt32(0).asData)  // image width in pixels
    self.suiteData.append(UInt32(0).asData)  // image height in pixels
    self.suiteData.append(4)  // Channels.rgba32
    self.suiteData.append(1)  // all channels have linear colorspace
  }

  @Test func decodeImageWithIndexToEmptyArray() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(3).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(1).asData)  // height

    testData.append(0b00_000000)
    testData.append(0b00_101010)
    testData.append(0b00_111111)

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ 3 + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 3)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 12)

    for u: UInt in 0..<3 {
      #expect(
        image.at(x: u, y: 0) as? Rgba32
          == Rgba32(red: 0, green: 0, blue: 0, alpha: 0),
        "x: \(u), y: \(0)")
    }
  }

  @Test func decodeImageWithIndexToIncompleteArray() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(3).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(3).asData)  // height

    // Partially fill the running array
    testData.append(contentsOf: [0b11111111, 255, 255, 255, 240])  // Index 1
    testData.append(contentsOf: [0b11111111, 89, 144, 233, 255])  // Index 47
    testData.append(contentsOf: [0b11111111, 255, 255, 255, 234])  // Index 63

    // Indexed pixels
    testData.append(0b00_000001)
    testData.append(0b00_101111)
    testData.append(0b00_111111)

    // Pixels still zero initialised
    testData.append(0b00_000000)
    testData.append(0b00_101010)
    testData.append(0b00_111110)

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (15 + 6) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 3)
    #expect(image.height == 3)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 36)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 255, green: 255, blue: 255, alpha: 240))
    try #require(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 89, green: 144, blue: 233, alpha: 255))
    try #require(
      image.at(x: 2, y: 0) as? Rgba32
        == Rgba32(red: 255, green: 255, blue: 255, alpha: 234))

    #expect(
      image.at(x: 0, y: 1) as? Rgba32
        == Rgba32(red: 255, green: 255, blue: 255, alpha: 240))
    #expect(
      image.at(x: 1, y: 1) as? Rgba32
        == Rgba32(red: 89, green: 144, blue: 233, alpha: 255))
    #expect(
      image.at(x: 2, y: 1) as? Rgba32
        == Rgba32(red: 255, green: 255, blue: 255, alpha: 234))

    for u: UInt in 0..<3 {
      #expect(
        image.at(x: u, y: 2) as? Rgba32
          == Rgba32(red: 0, green: 0, blue: 0, alpha: 0),
        "x: \(u), y: \(2)")
    }
  }

  @Test func decodeImageWithIndexToRepopulatedArray() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(2).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(2).asData)  // height

    // Partially fill the running array
    testData.append(contentsOf: [0b11111111, 89, 144, 233, 255])  // Index 47
    testData.append(contentsOf: [0b11111111, 13, 17, 32, 217])  // Also index 47

    // Indexed pixels
    testData.append(0b00_101111)

    // Pixels still zero initialised
    testData.append(0b00_000000)

    testData.append(contentsOf: footer)

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (10 + 2) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 2)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 16)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 89, green: 144, blue: 233, alpha: 255))
    try #require(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 13, green: 17, blue: 32, alpha: 217))

    #expect(
      image.at(x: 0, y: 1) as? Rgba32
        == Rgba32(red: 13, green: 17, blue: 32, alpha: 217))
    #expect(
      image.at(x: 1, y: 1) as? Rgba32
        == Rgba32(red: 0, green: 0, blue: 0, alpha: 0))
  }
}

@Suite("QOI_OP_Diff") struct DecodeDiff {
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

  @Test func decodeImageWithDifferenceToRgba32Pixel() async throws {
    let testData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 8)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))

    #expect(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 255, green: 1, blue: 43, alpha: 166))
  }
}

@Suite("QOI_OP_LUMA") struct DecodeLuma {
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

  @Test func decodeImageWithLumaDifferenceToRgba32Pixel() async throws {
    let testData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 2) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 8)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))

    #expect(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 243, green: 252, blue: 44, alpha: 166))
  }
}

@Suite("QOI_OP_RUN") struct DecodeRun {
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

  @Test func decodeImageWithOneRepeatedPixel() async throws {
    let testData: Data = suiteData

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 2)
    #expect(image.height == 1)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 8)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))

    #expect(
      image.at(x: 1, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))
  }

  @Test func decodeImageWithMultipleRepeatedPixels() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(7).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(6).asData)  // height

    let runIndex = 19
    try #require(testData[runIndex] == 0b11_000000)
    testData[runIndex] = 0b11_101000

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 7)
    #expect(image.height == 6)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 168)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))

    for u: UInt in 1..<7 {
      for v: UInt in 1..<6 {
        #expect(
          image.at(x: u, y: v) as? Rgba32
            == Rgba32(red: 0, green: 1, blue: 42, alpha: 166),
          "x: \(u), y: \(v)")
      }
    }
  }

  @Test func decodeImageWithMaximumRepeatedPixels() async throws {
    var testData: Data = suiteData

    testData.replaceSubrange(4..<8, with: UInt32(21).asData)  // width
    testData.replaceSubrange(8..<12, with: UInt32(3).asData)  // height

    let runIndex = 19
    try #require(testData[runIndex] == 0b11_000000)
    testData[runIndex] = 0b11_111101

    let expectedDataLength: UInt =
      /*header*/ 14 + /*pixels*/ (5 + 1) + /*end marker*/ 8

    try #require(testData.count == expectedDataLength)

    let image = try #require(QuiteOkImage(bytes: testData))

    #expect(image.width == 21)
    #expect(image.height == 3)
    #expect(image.colorspace == .linear)
    #expect(image.channels == .rgba32)
    #expect(image.data.count == 252)

    try #require(
      image.at(x: 0, y: 0) as? Rgba32
        == Rgba32(red: 0, green: 1, blue: 42, alpha: 166))

    for u: UInt in 1..<21 {
      for v: UInt in 1..<3 {
        #expect(
          image.at(x: u, y: v) as? Rgba32
            == Rgba32(red: 0, green: 1, blue: 42, alpha: 166),
          "x: \(u), y: \(v)")
      }
    }
  }
}
