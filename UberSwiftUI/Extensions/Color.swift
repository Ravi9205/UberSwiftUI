//
//  Color.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 06/01/23.
//

import Foundation
import SwiftUI


extension Color{
    static let theme = ColorTheme()
}

struct  ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
