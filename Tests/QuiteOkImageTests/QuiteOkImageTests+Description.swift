import Cqoi
import Testing

@testable import QuiteOkImage

@Test func readDescription() throws {
  let image = try #require(
    QuiteOkImage(
      data: Array(repeating: 0, count: 24),
      width: 2,
      height: 4,
      channels: .rgb24
    )
  )

  let description: qoi_desc = image.description

  #expect(description.channels == 3)
  #expect(description.colorspace == 1)
  #expect(description.height == 4)
  #expect(description.width == 2)
}
