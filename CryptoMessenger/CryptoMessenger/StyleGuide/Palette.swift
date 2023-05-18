import Foundation
import SwiftUI

// MARK: - Palette

enum Palette: Hashable {

    // MARK: - Types

    case clear,
         // 1A2E35 black
         black(_ alpha: CGFloat = 1),
         // 222222 black
         black222222(_ alpha: CGFloat = 1),
         // F5F6F8 light gray
         lightGray(_ alpha: CGFloat = 1),
         // E6EAED gray
         grayE6EAED(_ alpha: CGFloat = 1),
         gray768286(_ alpha: CGFloat = 1),
         // DAE1E9 gray
         grayDAE1E9(_ alpha: CGFloat = 1),
         // CED3D9 gray
         gray(_ alpha: CGFloat = 1),
         darkGray(_ alpha: CGFloat = 1),
         white(_ alpha: CGFloat = 1),
         blue(_ alpha: CGFloat = 1),
         // 03DAC5 green
         green(_ alpha: CGFloat = 1),
         blueABC3D5(_ alpha: CGFloat = 1),
         lightBlue(_ alpha: CGFloat = 1),
         // EEF4FB blue
         paleBlue(_ alpha: CGFloat = 1),
         red(_ alpha: CGFloat = 1),
         beige(_ alpha: CGFloat = 1),
         gray335664(_ alpha: CGFloat = 1),
         // E81E62 red
         lightRed(_ alpha: CGFloat = 1),
         darkBlack(_ alpha: CGFloat = 1),
         lightOrange(_ alpha: CGFloat = 1),
         purple(_ alpha: CGFloat = 1),
         paleGray(_ alpha: CGFloat = 1),
         blue3E729E(_ alpha: CGFloat = 1),
         gray6589A8(_ alpha: CGFloat = 1),
         grayA5A4A7(_ alpha: CGFloat = 1),
         red2323098(_ alpha: CGFloat = 1),
         custom(_ color: UIColor)

    // MARK: - Internal Properties

    var uiColor: UIColor {
        switch self {
        case .clear:
            return .clear
        case let .black(alpha):
            return #colorLiteral(red: 0.1019607843, green: 0.1803921569, blue: 0.2078431373, alpha: 1).withAlphaComponent(alpha)
        case let .black222222(alpha):
            return #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1).withAlphaComponent(alpha)
        case let .gray(alpha):
            return #colorLiteral(red: 0.8078431373, green: 0.8274509804, blue: 0.8509803922, alpha: 1).withAlphaComponent(alpha)
        case let .lightGray(alpha):
            return #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9725490196, alpha: 1).withAlphaComponent(alpha)
        case let .white(alpha):
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(alpha)
        case let .blue(alpha):
            return #colorLiteral(red: 0.05490196078, green: 0.5568627451, blue: 0.9529411765, alpha: 1).withAlphaComponent(alpha)
        case let .green(alpha):
            return #colorLiteral(red: 0.01176470588, green: 0.8549019608, blue: 0.7725490196, alpha: 1).withAlphaComponent(alpha)
        case let .lightBlue(alpha):
            return #colorLiteral(red: 0.8117647059, green: 0.9098039216, blue: 0.9921568627, alpha: 1).withAlphaComponent(alpha)
        case let .paleBlue(alpha):
            return #colorLiteral(red: 0.9333333333, green: 0.9568627451, blue: 0.9843137255, alpha: 1).withAlphaComponent(alpha)
        case let .red(alpha):
            return #colorLiteral(red: 0.9098039216, green: 0.1176470588, blue: 0.3843137255, alpha: 1).withAlphaComponent(alpha)
        case let .beige(alpha):
            return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1).withAlphaComponent(alpha)
        case let .darkGray(alpha):
            return #colorLiteral(red: 0.462745098, green: 0.5098039216, blue: 0.5254901961, alpha: 1).withAlphaComponent(alpha)
        case let .lightRed(alpha):
            return #colorLiteral(red: 0.9098039216, green: 0.1176470588, blue: 0.3843137255, alpha: 1).withAlphaComponent(alpha)
        case let .darkBlack(alpha):
            return #colorLiteral(red: 0.03921568627, green: 0.03921568627, blue: 0.03921568627, alpha: 1).withAlphaComponent(alpha)
        case let .lightOrange(alpha):
            return #colorLiteral(red: 0.9843137255, green: 0.6274509804, blue: 0.3019607843, alpha: 1).withAlphaComponent(alpha)
        case let .custom(color):
            return color
        case let .grayE6EAED(alpha):
            return #colorLiteral(red: 0.9019607843, green: 0.9176470588, blue: 0.9294117647, alpha: 1).withAlphaComponent(alpha)
        case let .gray768286(alpha):
            return #colorLiteral(red: 0.462745098, green: 0.5098039216, blue: 0.5254901961, alpha: 1).withAlphaComponent(alpha)
        case let .blueABC3D5(alpha):
            return #colorLiteral(red: 0.6705882353, green: 0.7647058824, blue: 0.8352941176, alpha: 1).withAlphaComponent(alpha)
        case let .gray335664(alpha):
            return #colorLiteral(red: 0.1294117647, green: 0.2196078431, blue: 0.2509803922, alpha: 1).withAlphaComponent(alpha)
        case let .purple(alpha):
            return #colorLiteral(red: 0.2784313725, green: 0.3098039216, blue: 0.5333333333, alpha: 1).withAlphaComponent(alpha)
        case let .grayDAE1E9(alpha):
            return #colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1).withAlphaComponent(alpha)
        case let .blue3E729E(alpha):
            return #colorLiteral(red: 0.2431372549, green: 0.4470588235, blue: 0.6196078431, alpha: 1).withAlphaComponent(alpha)
        case let .gray6589A8(alpha):
            return #colorLiteral(red: 0.3960784314, green: 0.537254902, blue: 0.6588235294, alpha: 1).withAlphaComponent(alpha)
        case let .paleGray(alpha):
            return #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1).withAlphaComponent(alpha)
        case let .grayA5A4A7(alpha):
            return #colorLiteral(red: 0.6470588235, green: 0.6431372549, blue: 0.6549019608, alpha: 1).withAlphaComponent(alpha)
        case let .red2323098(alpha):
            return #colorLiteral(red: 0.9098039216, green: 0.1176470588, blue: 0.3843137255, alpha: 1).withAlphaComponent(alpha)
        }
    }

    var suColor: Color { Color(uiColor) }

    var cgColor: CGColor { uiColor.cgColor }

    // MARK: - Internal Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(uiColor)
    }
}
