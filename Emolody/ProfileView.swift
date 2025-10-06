//
//  ProfileView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//
//  ProfileView.swift
//  Emolody
//
//  Updated to work with Router + unified styling

import SwiftUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var isSpotifyConnected = true
    @State private var isAppleMusicConnected = false

    var openPreferences: (() -> Void)?
    var openMusicPrefs: (() -> Void)?
    var onLogout: (() -> Void)?

    var body: some View {
        ZStack {
            ScreenBackground() // ← الخلفية من DesignSystem

            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - User Card
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Brand.primary.opacity(0.2))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(Brand.primary)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("User")
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)
                            Text("+1 (123) 456-7890")
                                .font(.subheadline)
                                .foregroundStyle(Brand.textSecondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 6)

                    // MARK: - Dark Mode Toggle
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(Brand.primary)
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .tint(Brand.primary)
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 6)

                    // MARK: - Preferences
                    Button {
                        (openMusicPrefs ?? openPreferences)?()
                    } label: {
                        HStack {
                            Image(systemName: "music.note.list")
                                .foregroundStyle(Brand.primary)
                            Text("Music & Podcast Preferences")
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
                    }

                    // MARK: - Connected Accounts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Connected Accounts")
                            .font(.headline)
                            .foregroundStyle(Brand.textPrimary)
                            .padding(.horizontal, 4)

                        HStack {
                            Image("spotifyLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Spotify")
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)
                            Spacer()
                            Toggle("", isOn: $isSpotifyConnected)
                                .labelsHidden()
                                .tint(Brand.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)

                        HStack {
                            Image("appleMusicLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                            Text("Apple Music")
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)
                            Spacer()
                            Toggle("", isOn: $isAppleMusicConnected)
                                .labelsHidden()
                                .tint(Brand.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                    }

                    // MARK: - Logout
                    Button {
                        onLogout?()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundStyle(.red)
                            Text("Logout")
                                .font(.headline)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
