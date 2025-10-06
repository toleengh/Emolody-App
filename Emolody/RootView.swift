//
//  RootView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//
//
//  RootView.swift
//  Emolody
//
import SwiftUI
import Combine
import AVFoundation

enum Route: Hashable {
    case splash
    case enterPhone
    case verifyPhone(number: String)
    case preferences
    case askName
    case cameraPermission
    case moodDetection
    case mainTabs
    case playlist(mood: String)
    case settings
    case profile
}

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    func go(_ r: Route) { path.append(r) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path.removeLast(path.count) }
}

struct RootView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var camera = CameraService()
    @StateObject private var user = UserStore()

    var body: some View {
        NavigationStack(path: $router.path) {
            // البداية: Splash → EnterPhone
            SplashView { router.go(.enterPhone) }
                .navigationDestination(for: Route.self) { route in
                    switch route {

                    case .splash:
                        SplashView { router.go(.enterPhone) }

                    case .enterPhone:
                        EnterPhoneNumberView { number in
                            router.go(.verifyPhone(number: number))
                        }

                    case .verifyPhone:
                        VerifyNumberView(phoneNumber: "•••") {
                            // بعد التحقق → التفضيلات أولًا
                            router.go(.preferences)
                        }

                    case .preferences:
                        PreferencesView(user: user) {
                            router.go(.askName)
                        }

                    case .askName:
                        AskNameView(user: user) {
                            // بعد الاسم → إلى التبويبات مباشرة (بدون إذن كاميرا الآن)
                            router.go(.mainTabs)
                        }

                    case .cameraPermission:
                        CameraPermissionView(camera: camera)
                            .onChange(of: camera.isAuthorized) { ok in
                                if ok { router.go(.moodDetection) }
                            }
                            .onAppear {
                                camera.isAuthorized = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
                            }

                    case .moodDetection:
                        MoodDetectionView(camera: camera) {
                            // بعد الانتهاء نحفظ المود ونفتح البلاي ليست
                            let mood = camera.moodText.isEmpty ? "Happy" : camera.moodText
                            user.lastMood = mood
                            user.save()
                            router.go(.playlist(mood: mood))
                        }
                        .navigationBarTitleDisplayMode(.inline)

                    case .mainTabs:
                        MainTabView(
                            user: user,
                            openPlaylist: { mood in router.go(.playlist(mood: mood)) },
                            startMoodDetection: {
                                // من الهوم: نطلب إذن كاميرا أولًا
                                router.go(.cameraPermission)
                            },
                            openProfile: { router.go(.profile) }
                        )

                    case .playlist(let mood):
                        PlaylistView(
                            moodLabel: mood,
                            songs: [
                                .init(title: "Happy Together", artist: "The Turtles", duration: "2:56"),
                                .init(title: "Can't Stop the Feeling", artist: "Justin Timberlake", duration: "3:56"),
                                .init(title: "Walking on Sunshine", artist: "Katrina & The Waves", duration: "3:43")
                            ],
                            openSpotify: {
                                if let url = URL(string: "https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlC") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )

                    case .settings:
                        SettingsPlaceholder()

                    case .profile:
                        ProfileView(
                            openPreferences: { router.go(.preferences) },
                            openMusicPrefs: { router.go(.settings) },
                            onLogout: {
                                user.name = ""
                                user.genres.removeAll()
                                user.activities.removeAll()
                                user.lastMood = ""
                                user.save()
                                router.popToRoot()
                            }
                        )
                    }
                }
        }
        .environmentObject(router)
    }
}



import SwiftUI

/// شاشة إعدادات بسيطة مؤقتة.
/// تقدرون توسعونها لاحقًا. فيها زر يفتح شاشة التفضيلات.
struct SettingsPlaceholder: View {
    @EnvironmentObject var router: AppRouter
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var notifications = true

    var body: some View {
        ZStack {
            ScreenBackground()

            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .tint(Brand.primary)
                }

                Section("Notifications") {
                    Toggle("Enable notifications", isOn: $notifications)
                        .tint(Brand.primary)
                }

                Section("Preferences") {
                    Button {
                        router.go(.preferences)   // يفتح شاشة تفضيلات المستخدم
                    } label: {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(Brand.primary)
                            Text("Edit music & podcast preferences")
                                .foregroundStyle(Brand.textPrimary)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
