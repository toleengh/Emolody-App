//
//  PlayListView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

struct PlaylistView: View {
    var moodLabel: String
    var moodEmoji: String = "😊"
    var songs: [SongItem]
    var openSpotify: (() -> Void)?
    var openAppleMusic: (() -> Void)?

    @State private var isShareSheetPresented = false

    var body: some View {
        ZStack {
            ScreenBackground()

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Mood Playlist")
                        .font(.title).bold()
                        .foregroundStyle(Brand.textPrimary)

                    HStack(spacing: 8) {
                        Text("\(moodEmoji) You are feeling:")
                            .font(.subheadline)
                            .foregroundStyle(Brand.textSecondary)
                        Text(moodLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Brand.primary)
                    }

                    HStack(spacing: 12) {
                        Button { openSpotify?() } label: {
                            Label("Open in Spotify", systemImage: "arrow.up.right.square")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Brand.primary)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                                .shadow(color: Brand.primary.opacity(0.18), radius: 8, y: 4)
                        }

                        Button { isShareSheetPresented = true } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .foregroundStyle(Brand.textPrimary)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(colors: [Brand.bg1, Brand.bg2], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.6)
                )

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(songs) { item in
                            SongRow(title: item.title, artist: item.artist, duration: item.duration)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityViewController(
                activityItems: ["Check out my \(moodLabel) Mood Playlist! https://emolody.app/share/playlist"]
            )
        }
    }
}

struct SongItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let duration: String
}

private struct SongRow: View {
    var title: String
    var artist: String
    var duration: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 28))
                .foregroundStyle(.gray)

        VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline).foregroundStyle(Brand.textPrimary)
                Text(artist).font(.subheadline).foregroundStyle(Brand.textSecondary)
            }
            Spacer()
            Text(duration).font(.subheadline).foregroundStyle(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
