//
//  PlaylistView.swift
//  Emolody
//
//  Created by toleen alghamdi on 28/04/1447 AH.
//

import SwiftUI

struct SongItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let duration: String
}

struct PlaylistView: View {
    let moodLabel: String
    let songs: [SongItem]
    var openSpotify: () -> Void = {}

    var body: some View {
        ZStack {
            AppScreenBackground()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 14) {
                    Text("Your Mood Playlist")
                        .font(.title).bold()
                        .foregroundColor(Brand.textPrimary)

                    Text("😊 You are feeling: \(moodLabel)")
                        .font(.subheadline)
                        .foregroundColor(Brand.textSecondary)

                    HStack(spacing: 12) {
                        Button(action: openSpotify) {
                            Text("Open in Spotify")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Brand.primary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Brand.primary.opacity(0.2), radius: 8, y: 4)
                        }

                        ShareLink(
                            item: URL(string: "https://emolody.app/share/playlist")!,
                            subject: Text("My \(moodLabel) Mood Playlist"),
                            message: Text("Check out my \(moodLabel) Mood Playlist!")
                        ) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Brand.card)
                                .foregroundColor(Brand.textPrimary)
                                .cornerRadius(12)
                                .shadow(color: Brand.shadow, radius: 6, y: 3)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color.yellow.opacity(0.35), Color.orange.opacity(0.35)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )

                // Songs
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(songs) { s in
                            SongRow(title: s.title, artist: s.artist, duration: s.duration)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SongRow: View {
    var title: String
    var artist: String
    var duration: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Brand.textPrimary)
                Text(artist)
                    .font(.subheadline)
                    .foregroundColor(Brand.textSecondary)
            }
            Spacer()
            Text(duration)
                .font(.subheadline)
                .foregroundColor(Brand.textSecondary)
        }
        .appCard()
    }
}
