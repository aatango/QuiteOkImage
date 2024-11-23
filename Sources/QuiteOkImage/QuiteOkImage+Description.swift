import Cqoi

extension QuiteOkImage {
  var description: qoi_desc {
    var _channels: UInt8 {
      switch self.channels {
        case .rgb24: 3
        case .rgba32: 4
      }
    }

    var _colorspace: UInt8 {
      switch self.colorspace {
        case .linear: 1
        case .sRGB: 0
      }
    }

    return qoi_desc(
      width: UInt32(self.width),
      height: UInt32(self.height),
      channels: _channels,
      colorspace: _colorspace)
  }
}
