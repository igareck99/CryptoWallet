import SwiftUI

protocol SelectTokenResourcable {
    static var background: Color { get }
}

enum SelectTokenResources: SelectTokenResourcable {
    static var background: Color {
        .white
    }
}
