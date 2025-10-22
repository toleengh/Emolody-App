//
//  HomeView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var user: UserStore
    var startMoodDetection: () -> Void
    var openPlaylist: (String) -> Void

    var body: some View {
        ZStack {
            AppScreenBackground()

            VStack(spacing: 20) {

                // Greeting (بالاسم إن وجد)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hello\(user.name.isEmpty ? "" : ", \(user.name)")!")
                        .font(.title).bold()
                        .foregroundStyle(Brand.textPrimary)
                    Text("How are you feeling today?")
                        .font(.subheadline)
                        .foregroundStyle(Brand.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 40)

                Spacer()

                // Mood Detection Button
                Button(action: startMoodDetection) {
                    Text("Start\nMood Detection")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(50)
                        .background(Circle().fill(Brand.primary))
                        .shadow(radius: 10)
                }

                Spacer()

                // Last Detected Mood
                if !user.lastMood.isEmpty {
                    HStack {
                        Text("😊 \(user.lastMood)\nLast detected recently")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Spacer()
                        Button("View Playlist") {
                            openPlaylist(user.lastMood)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    )
                    .padding(.horizontal)
                }

                // Suggested (بناءً على التفضيلات لاحقًا)
                VStack(spacing: 15) {
                    SuggestedRow(title: "Happy Vibes", type: "Playlist") {
                        openPlaylist("Happy")
                    }
                    SuggestedRow(title: "Motivational Podcasts", type: "Podcast") {
                        // open podcasts tab
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

struct SuggestedRow: View {
    let title: String
    let type: String
    var onOpen: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.headline).foregroundStyle(Brand.textPrimary)
                Text(type).font(.caption).foregroundStyle(Brand.textSecondary)
            }
            Spacer()

            Button("Open", action: onOpen)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
