import UIKit

// MARK: UIColor ()

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }

    func RGBtoCMYK(red: CGFloat, green: CGFloat, blue: CGFloat) -> (
        cyan: CGFloat,
        magenta: CGFloat,
        yellow: CGFloat,
        key: CGFloat
    ) {
        if red == 0, green == 0, blue == 0 { return (0, 0, 0, 1) }
        var cyan = 1 - red
        var magenta = 1 - green
        var yellow = 1 - blue
        let minCMY = min(cyan, magenta, yellow)
        cyan = (cyan - minCMY) / (1 - minCMY)
        magenta = (magenta - minCMY) / (1 - minCMY)
        yellow = (yellow - minCMY) / (1 - minCMY)
        return (cyan, magenta, yellow, minCMY)
    }

    func CMYKtoRGB(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat) -> (
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) {
        let red = (1 - cyan) * (1 - key)
        let green = (1 - magenta) * (1 - key)
        let blue = (1 - yellow) * (1 - key)
        return (red, green, blue)
    }

    func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue)
        let kVal = originCMYK.key > 0.3 ? originCMYK.key - 0.2 : originCMYK.key + 0.2
        let tintRGB = CMYKtoRGB(
            cyan: originCMYK.cyan,
            magenta: originCMYK.magenta,
            yellow: originCMYK.yellow,
            key: kVal
        )
        return UIColor(red: tintRGB.red, green: tintRGB.green, blue: tintRGB.blue, alpha: 1)
    }
}
