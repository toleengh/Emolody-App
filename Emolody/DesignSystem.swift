//
//  DesignSystem.swift
//  emolody2
//
//  Created by toleen alghamdi on 08/04/1447 AH.
//

import SwiftUI

// ألوان وهوية التطبيق – تُعرّف مرة واحدة فقط
enum Brand {
    static let primary       = Color(red: 0.53, green: 0.40, blue: 0.96)
    static let purple        = primary
    static let bg1           = Color(red: 0.97, green: 0.95, blue: 0.99)
    static let bg2           = Color(red: 0.95, green: 0.92, blue: 0.99)
    static let textPrimary   = Color.black.opacity(0.9)
    static let textSecondary = Color.black.opacity(0.6)
}

// خلفية موحّدة
struct ScreenBackground: View {
    var body: some View {
        LinearGradient(colors: [Brand.bg1, Brand.bg2],
                       startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
}
