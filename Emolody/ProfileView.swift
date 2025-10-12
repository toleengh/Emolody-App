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

    // إعدادات
    @AppStorage("isDarkMode") private var isDarkMode = false

    var openPreferences: () -> Void
    var openMusicPrefs: () -> Void   // نستخدمه لفتح نفس شاشة الإعداد الأولي لو حبيتي
    var onLogout: () -> Void

    @State private var showPrefsSummary = false

    var body: some View {
        ZStack {
            ScreenBackground()

            ScrollView {
                VStack(spacing: 16) {

                    // بطاقة المستخدم
                    HStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Brand.primary.opacity(0.18))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Brand.primary)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name.isEmpty ? "User" : user.name)
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)

                            Text(user.phone.isEmpty ? "No phone" : user.phone)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 3)

                    // Dark Mode
                    HStack {
                        Text("Dark Mode")
                            .font(.headline)
                            .foregroundStyle(Brand.textPrimary)
                        Spacer()
                        Toggle("", isOn: $isDarkMode)
                            .labelsHidden()
                            .tint(Brand.primary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 3)

                    // Music & Podcast Preferences
                    Button {
                        showPrefsSummary = true   // ← يعرض الملخص
                    } label: {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(Brand.primary)
                            Text("Music & Podcast Preferences")
                                .font(.headline)
                                .foregroundStyle(Brand.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
                    }

                    // Logout
                    Button(role: .destructive) {
                        onLogout()     // ← يرجّع لصفحة تسجيل الدخول
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                            Text("Logout")
                                .font(.headline)
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showPrefsSummary) {
            PreferencesSummarySheet(user: user)
                .presentationDetents([.medium, .large])
        }
    }
}

// ملخّص التفضيلات في ورقة (sheet)
private struct PreferencesSummarySheet: View {
    @ObservedObject var user: UserStore

    var body: some View {
        NavigationStack {
            List {
                if !user.genres.isEmpty {
                    Section("Favorite genres") {
                        ForEach(Array(user.genres.sorted()), id: \.self) { g in
                            Text(g)
                        }
                    }
                }
                if !user.activities.isEmpty {
                    Section("Activities") {
                        ForEach(Array(user.activities.sorted()), id: \.self) { a in
                            Text(a)
                        }
                    }
                }
                if user.genres.isEmpty && user.activities.isEmpty {
                    Text("No preferences selected yet.")
                        .foregroundStyle(.gray)
                }
            }
            .navigationTitle("Your preferences")
        }
    }
}
