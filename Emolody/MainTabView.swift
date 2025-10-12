//
//  MainTabView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
import SwiftUI

struct MainTabView: View {
    @ObservedObject var user: UserStore
    var openPlaylist: (String) -> Void
    var startMoodDetection: () -> Void
    var openProfile: () -> Void   // احتياطي لو حبيتي تفتحي شاشة بروفايل منفصلة

    var body: some View {
        TabView {
            // Home
            HomeView(
                user: user,
                startMoodDetection: startMoodDetection,
                openPlaylist: openPlaylist
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            // Playlists
            PlaylistIndexView(openPlaylist: openPlaylist)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Playlists")
                }

            // Podcasts
            PodcastsView()
                .tabItem {
                    Image(systemName: "mic.fill")
                    Text("Podcasts")
                }

            // Profile (نعرضه مباشرة)
            ProfileView(
                user: user,                 // ← هنا الصح
                openPreferences: {},        // بإمكانك لاحقًا تربطيها بـ router.go(.onboardingProfile)
                openMusicPrefs: {},
                onLogout: {}                // زر اللوق آوت الحقيقي موجود في شاشة Profile التي تفتح من Route.profile
            )
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
    }
}
