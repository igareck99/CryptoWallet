import SwiftUI
import UIKit

extension UIColor {
    // MARK: - New Collors
    // Main collors
    // #121315
    static let chineseBlack = UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 21.0 / 255.0, alpha: 1.0)
    // #121315 opacity = 0.05
    static let chineseBlackLoad = UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 21.0 / 255.0, alpha: 0.05)
    // #121315 opacity = 0.4
    static let chineseBlack04 = UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 21.0 / 255.0, alpha: 0.4)
    // #8a919c or #89909B
    //#121315 opacity = 0.05
    static var chineseShadow = UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 21.0 / 255.0, alpha: 0.05)
    //#8a919c or #89909B
    static let romanSilver = UIColor(red: 137.0 / 255.0, green: 144.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0)
    // #8a919 copacity = 0.7
    static let romanSilver07 = UIColor(red: 137.0 / 255.0, green: 144.0 / 255.0, blue: 155.0 / 255.0, alpha: 0.7)
    // #E1DCCD
    //#8a919
    static let romanSilver01 = UIColor(red: 137.0 / 255.0, green: 144.0 / 255.0, blue: 155.0 / 255.0, alpha: 0.1)
    //#E1DCCD
    static let bone = UIColor(red: 225.0 / 255.0, green: 220.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
    // #eaeced
    static let brightGray = UIColor(red: 234.0 / 255.0, green: 236.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    // #dcdfe2
    static let gainsboro = UIColor(red: 220.0 / 255.0, green: 223.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    // #F2F7FC
    static let aliceBlue = UIColor(red: 242.0 / 255.0, green: 247.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    // #EDF3F8
    static let antiFlashWhite = UIColor(red: 237.0 / 255.0, green: 243.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    // #DDF0FF
    static let water = UIColor(red: 221.0 / 255.0, green: 240.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    // #BFE3FF
    static let diamond = UIColor(red: 191.0 / 255.0, green: 227.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    // #B6D5F2
    static let beauBlue = UIColor(red: 182.0 / 255.0, green: 213.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    // #3FAAFF
    static let brilliantAzure = UIColor(red: 63.0 / 255.0, green: 170.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    // #0E8EF3
    static let dodgerBlue = UIColor(red: 14.0 / 255.0, green: 142.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    // #0E8EF3
    static let dodgerTransBlue = UIColor(red: 14.0 / 255.0, green: 142.0 / 255.0, blue: 243.0 / 255.0, alpha: 0.1)
    // #FFFFFF
    static let white = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    // #FFFFFF
    static let transWhite = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.6)
    // #27AE60
    static let greenCrayola = UIColor(red: 39.0 / 255.0, green: 174.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
    // #E81E4E
    static let spanishCrimson = UIColor(red: 232.0 / 255.0, green: 30.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    // #EC9B3C
    //#E81E4E
    static let spanishCrimson01 = UIColor(red: 232.0 / 255.0, green: 30.0 / 255.0, blue: 78.0 / 255.0, alpha: 0.1)
    //#EC9B3C
    static let royalOrange = UIColor(red: 236.0 / 255.0, green: 155.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    // #8E9298
    static let osloGrayApprox = UIColor(red: 142.0 / 255.0, green: 146.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)

    // Shadow collors
    // #40454c
    static let outerSpace = UIColor(red: 64.0 / 255.0, green: 69.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
    // #6f7783
    static let auroMetalSaurus = UIColor(red: 111.0 / 255.0, green: 119.0 / 255.0, blue: 132.0 / 255.0, alpha: 1.0)
    // #7C8490
    static let smokyStudio = UIColor(red: 124.0 / 255.0, green: 132.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
    // #979ea7 #8a919c
    static let manatee = UIColor(red: 138.0 / 255.0, green: 145.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    // #a5abb3
    static let metallicSilver = UIColor(red: 165.0 / 255.0, green: 171.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
    // #b3b8bf
    static let ashGray = UIColor(red: 179.0 / 255.0, green: 184.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    // #CFD2D6
    static let lightGray = UIColor(red: 207.0 / 255.0, green: 210.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    // #f8f9f9
    static let ghostWhite = UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    // #E6F4FF
    //#f8f9f9
    static let ghostWhite04 = UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 0.4)
    //#E6F4FF
    static let bubbles = UIColor(red: 230.0 / 255.0, green: 244.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    // #239c56
    static let seaGreen = UIColor(red: 35.0 / 255.0, green: 156.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
    // #693d0a
    static let philippineBronze = UIColor(red: 105.0 / 255.0, green: 61.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)

    // Main dark collors
    // #F6F6F6
    static let cultured = UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    // #636A75
    static let dimGray = UIColor(red: 99.0 / 255.0, green: 106.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    // #22201A
    static let eerieBlack = UIColor(red: 34.0 / 255.0, green: 32.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
    // #1D1F23
    static let darkJungleGreen = UIColor(red: 29.0 / 255.0, green: 31.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    // #2B4156
    static let charcoal = UIColor(red: 43.0 / 255.0, green: 65.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
    // #24679C
    static let lapisLazuli = UIColor(red: 36.0 / 255.0, green: 103.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    // #4076A0
    static let queenBlue = UIColor(red: 64.0 / 255.0, green: 118.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0)
    // #6E8498
    static let slateGray = UIColor(red: 110.0 / 255.0, green: 132.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    // #1181DA
    static let brightNavyBlue = UIColor(red: 17.0 / 255.0, green: 129.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    // #148CEC
    static let outOfTheBlue = UIColor(red: 20.0 / 255.0, green: 140.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
    // #1E1E1E
    static let dynamicBlack = UIColor(red: 30.0 / 255.0, green: 30.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0)
    // #119F4D
    static let greenPigment = UIColor(red: 17.0 / 255.0, green: 159.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    // #C3153F
    static let сardinal = UIColor(red: 195.0 / 255.0, green: 21.0 / 255.0, blue: 63.0 / 255.0, alpha: 1.0)
    // #D68930
    static let chineseBronze = UIColor(red: 214.0 / 255.0, green: 137.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)

    // Shadow dark collors
    // #6F7783
    static let lunarShadow = UIColor(red: 111.0 / 255.0, green: 119.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0)
    // #666E7A
    static let nickel = UIColor(red: 102.0 / 255.0, green: 110.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    // #585E68
    static let blackCoral = UIColor(red: 88.0 / 255.0, green: 94.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    // #4C515A
    static let davysGrey = UIColor(red: 76.0 / 255.0, green: 81.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    // #292C30
    static let charlestonGreen = UIColor(red: 41.0 / 255.0, green: 44.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    // #060607
    static let vampireBlack = UIColor(red: 6.0 / 255.0, green: 6.0 / 255.0, blue: 7.0 / 255.0, alpha: 1.0)
    // #314F67
    static let policeBlue = UIColor(red: 49.0 / 255.0, green: 79.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)

    // MARK: - Old ones
    static let blackSqueezeApprox = UIColor(red: 237.0 / 255.0, green: 243.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    static let dodgerBlueApprox = UIColor(red: 63.0 / 255.0, green: 170.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let onahauApprox = UIColor(red: 205.0 / 255.0, green: 232.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    static let zeroColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let sailApprox = UIColor(red: 173.0 / 255.0, green: 214.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    static let cornflowerBlueApprox = UIColor(red: 101.0 / 255.0, green: 175.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    static let alabasterSolid = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    static let azureRadianceApprox = UIColor(red: 0.055, green: 0.557, blue: 0.953, alpha: 1)
    static let hawkesBlueApprox = UIColor(red: 0.812, green: 0.91, blue: 0.992, alpha: 1)
    static let pigeonPostApprox = UIColor(red: 0.71, green: 0.792, blue: 0.867, alpha: 1)
    static let nobelApprox = UIColor(red: 0.702, green: 0.702, blue: 0.702, alpha: 1)
    static let tundoraApprox = UIColor(red: 0.292, green: 0.292, blue: 0.292, alpha: 1)
    static let manateeApprox = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
    static let sharkApprox = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
    static let athensGrayApprox = UIColor(red: 0.902, green: 0.918, blue: 0.929, alpha: 1)
    static let ironApprox = UIColor(red: 220.0 / 255.0, green: 223.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    static let regentGrayApprox = UIColor(red: 138.0 / 255.0, green: 145.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    static let woodSmokeApprox = UIColor(red: 18.0 / 255.0, green: 19.0 / 255.0, blue: 21.0 / 255.0, alpha: 1.0)
    static let jaffaApprox = UIColor(red: 0.925, green: 0.608, blue: 0.235, alpha: 1)
    static let amaranthApprox = UIColor(red: 232.0 / 255.0, green: 30.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    static let bombayApprox = UIColor(red: 179.0 / 255.0, green: 184.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    static let blackHazeApprox = UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    static let white06 = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    static let polarApprox = UIColor(red: 242.0 / 255.0, green: 247.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    static let jungleGreenApprox = UIColor(red: 39.0 / 255.0, green: 174.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
}
