//
//  emolody2App.swift
//  emolody2
//
//  Created by toleen alghamdi on 04/04/1447 AH.
import SwiftUI

@main
struct EmolodyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light) // قفلنا الثيم على الفاتح
        }
    }
}
