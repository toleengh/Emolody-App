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
    @ObservedObject var user: UserStore

    var openPreferences: () -> Void = {}
    var onLogout: () -> Void = {}

    @State private var isSpotifyConnected = true
    @State private var isAppleMusicConnected = false

    var body: some View {
        NavigationView {
            ZStack {
                AppScreenBackground()

                ScrollView {
                    VStack(spacing: 16) {

                        // بطاقة المستخدم
                        AppCard {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Brand.primary.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 28, weight: .semibold))
                                            .foregroundColor(Brand.primary)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.name.isEmpty ? "User" : user.name)
                                        .font(.headline)
                                        .foregroundColor(Brand.textPrimary)
                                    Text(user.phone.isEmpty ? "—" : user.phone)
                                        .font(.subheadline)
                                        .foregroundColor(Brand.textSecondary)
                                }
                                Spacer()
                            }
                        }

                        // التفضيلات
                        Button(action: openPreferences) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(Brand.primary)
                                Text("Music & Podcast Preferences")
                                    .font(.headline)
                                    .foregroundColor(Brand.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Brand.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .appCard()

                        // الحسابات المرتبطة (تنظيم جاهز للتوصيل لاحقاً)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Connected Accounts")
                                .font(.headline)
                                .foregroundColor(Brand.textPrimary)
                                .padding(.horizontal)

                            AppCard {
                                HStack {
                                    Image("spotifyLogo")
                                        .resizable().scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("Spotify")
                                        .font(.headline).foregroundColor(Brand.textPrimary)
                                    Spacer()
                                    Toggle("", isOn: $isSpotifyConnected).labelsHidden()
                                }
                            }

                            AppCard {
                                HStack {
                                    Image("appleMusicLogo")
                                        .resizable().scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("Apple Music")
                                        .font(.headline).foregroundColor(Brand.textPrimary)
                                    Spacer()
                                    Toggle("", isOn: $isAppleMusicConnected).labelsHidden()
                                }
                            }
                        }

                        // تسجيل الخروج
                        Button(role: .destructive, action: onLogout) {
                            HStack {
                                Image(systemName: "arrow.right.square.fill")
                                Text("Logout").font(.headline)
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                        .appCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
