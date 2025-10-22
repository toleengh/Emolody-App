//
//  MainTabView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
import SwiftUI

struct MainTabView: View {
    @ObservedObject var user: UserStore

    // نستقبل إغلاقات من RootView
    var openPlaylist: (String) -> Void
    var startMoodDetection: () -> Void
    var openPreferences: () -> Void         // ← بدل openProfile()
    var logout: () -> Void                  // ← لزر اللوق آوت

    var body: some View {
        TabView {
            HomeView(
                user: user,
                startMoodDetection: startMoodDetection,
                openPlaylist: openPlaylist
            )
            .tabItem { Image(systemName: "house.fill"); Text("Home") }

            PlaylistIndexView(openPlaylist: openPlaylist)
                .tabItem { Image(systemName: "music.note.list"); Text("Playlists") }

            PodcastsView()
                .tabItem { Image(systemName: "mic.fill"); Text("Podcasts") }

            // نعرض البروفايل مباشرة
            ProfileView(
                user: user,
                openPreferences: openPreferences,  // ← يفتح شاشة التفضيلات
                onLogout: logout                   // ← يربط اللوق آوت الحقيقي
            )
            .tabItem { Image(systemName: "person.fill"); Text("Profile") }
        }
    }
}
