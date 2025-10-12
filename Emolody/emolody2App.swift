//
//  emolody2App.swift
//  emolody2
//
//  Created by toleen alghamdi on 04/04/1447 AH.
import SwiftUI

@main
struct EmolodyApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // ← يفعّل الداكن/الفاتح
        }
    }
}
