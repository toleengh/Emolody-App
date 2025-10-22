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
//  RootView.swift
//  Emolody
//

//
//  RootView.swift
//  Emolody
//

import SwiftUI
import AVFoundation
import Combine     // ← مهم لعلاقة ObservableObject/@Published

// MARK: - Routes
enum Route: Hashable {
    case splash
    case enterPhone
    case verifyPhone(number: String)
    case onboardingProfile         // اسم + اهتمامات (صفحة واحدة)
    case cameraPermission
    case moodDetection
    case mainTabs
    case playlist(mood: String)
    case settings                  // اختياري
    case profile
}

// MARK: - Router
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    func go(_ r: Route) { path.append(r) }

    /// يبدّل المسار كله بالشاشة المعطاة (مفيد لمنع الرجوع)
    func resetTo(_ r: Route) {
        path = NavigationPath()
        path.append(r)
    }

    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path.removeLast(path.count) }
}

// MARK: - RootView
struct RootView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var camera = CameraService()
    @StateObject private var user   = UserStore()

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

                    case .verifyPhone(let number):
                        VerifyNumberView(phoneNumber: number) {
                            user.phone = number
                            user.save()
                            router.go(.onboardingProfile)
                        }

                    case .onboardingProfile:
                        OnboardingProfileView(user: user) {
                            router.resetTo(.mainTabs) // يمنع الرجوع من الهوم
                        }

                    case .cameraPermission:
                        CameraPermissionView(
                            camera: camera,
                            onSkip: { router.resetTo(.mainTabs) } // Not Now → الهوم
                        )
                        .onChange(of: camera.isAuthorized) { ok in
                            if ok { router.go(.moodDetection) }
                        }
                        .onAppear {
                            camera.isAuthorized =
                              AVCaptureDevice.authorizationStatus(for: .video) == .authorized
                        }

                    case .moodDetection:
                        // تأكدي أن MoodDetectionView عندك يدعم onDone
                        MoodDetectionView(camera: camera) {
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
                            startMoodDetection: { router.go(.cameraPermission) },
                            openPreferences: { router.go(.onboardingProfile) },   // ✅ يفتح تفضيلات
                            logout: {
                                user.clear()
                                router.resetTo(.enterPhone)                       // ✅ يرجع صفحة الدخول
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                      

                    case .playlist(let mood):
                        PlaylistView(
                            moodLabel: mood,
                            songs: [
                                SongItem(title: "Happy Together",        artist: "The Turtles",              duration: "2:56"),
                                SongItem(title: "Can't Stop the Feeling", artist: "Justin Timberlake",        duration: "3:56"),
                                SongItem(title: "Walking on Sunshine",    artist: "Katrina & The Waves",      duration: "3:43")
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
                            user: user,                                  // ← مرّري المتغيّر instance مو النوع
                            openPreferences: { router.go(.onboardingProfile) },  // يفتح التفضيلات
                            onLogout: {
                                user.clear()
                                router.resetTo(.enterPhone)              // يرجع شاشة تسجيل الدخول
                            }
                        )
                    }
                }
        }
        .environmentObject(router)
    }
}

// MARK: - (اختياري) Placeholder بسيط للإعدادات
struct SettingsPlaceholder: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            AppScreenBackground()
            VStack(spacing: 16) {
                Text("Settings")
                    .font(.title2.bold())
                    .foregroundStyle(Brand.textPrimary)

                Button {
                    router.go(.onboardingProfile)
                } label: {
                    Text("Edit preferences")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Brand.primary)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
