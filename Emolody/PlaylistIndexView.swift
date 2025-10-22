//
//  PlaylistIndexView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

struct PlaylistIndexView: View {
    var openPlaylist: (String) -> Void

    var body: some View {
        ZStack {
            AppScreenBackground()
            VStack(spacing: 16) {
                Text("Playlists")
                    .font(.title2.bold())
                    .foregroundStyle(Brand.textPrimary)

                SuggestedRow(title: "Happy Vibes", type: "Playlist") {
                    openPlaylist("Happy")
                }
                SuggestedRow(title: "Chill Mood", type: "Playlist") {
                    openPlaylist("Chill")
                }
                Spacer()
            }
            .padding()
        }
    }
}
