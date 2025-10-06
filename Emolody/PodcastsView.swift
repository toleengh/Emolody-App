//
//  PodcastsView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

struct PodcastsView: View {
    var body: some View {
        ZStack {
            ScreenBackground()
            Text("Podcasts")
                .font(.title2.bold())
                .foregroundStyle(Brand.textPrimary)
        }
    }
}
