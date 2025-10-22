//
//  PodcastsView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

struct PodcastsView: View {
    struct Mood: Identifiable, Hashable {
        let id = UUID()
        let emoji: String
        let title: String
    }
    struct PodcastItem: Identifiable {
        let id = UUID()
        let title: String
        let author: String
        let short: String
        let category: String
        let mood: Mood
    }

    // الفئات (بدل Moods في الأصل)
    let categories: [Mood] = [
        .init(emoji: "😂", title: "Comedy"),
        .init(emoji: "🎓", title: "Educational"),
        .init(emoji: "🧘‍♂️", title: "Wellness"),
        .init(emoji: "⚽️", title: "Sports"),
        .init(emoji: "💻", title: "Technology"),
        .init(emoji: "🎙️", title: "Talk Show"),
        .init(emoji: "🔮", title: "Motivational"),
        .init(emoji: "🧠", title: "Science")
    ]

    @State private var selectedCategory: Mood?

    var podcasts: [PodcastItem] {
        [
            .init(title: "Laugh Factory", author: "Comedy Crew", short: "Funniest stories every week", category: "Comedy", mood: categories[0]),
            .init(title: "Tech Talk", author: "IT Experts", short: "Latest updates in tech", category: "Technology", mood: categories[4]),
            .init(title: "Mind Power", author: "Motivation FM", short: "Boost your mindset daily", category: "Motivational", mood: categories[6]),
            .init(title: "SportCast", author: "BallHub", short: "All about football & sports", category: "Sports", mood: categories[3]),
            .init(title: "Brain Boost", author: "EduPod", short: "Learn something new each episode", category: "Educational", mood: categories[1]),
            .init(title: "Wellness Hour", author: "Calm Radio", short: "Relaxation & health topics", category: "Wellness", mood: categories[2])
        ]
    }

    var filtered: [PodcastItem] {
        if let c = selectedCategory { return podcasts.filter { $0.mood == c } }
        return podcasts
    }

    var body: some View {
        ZStack {
            AppScreenBackground()

            VStack(spacing: 16) {
                Spacer().frame(height: 12)

                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Podcast Collections")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Brand.textPrimary)
                    Text("Select a podcast category to explore")
                        .font(.system(size: 15))
                        .foregroundStyle(Brand.textSecondary)
                }
                .padding(.horizontal, 20)

                ScrollView {
                    VStack(spacing: 18) {
                        // Categories
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Choose Podcast Category 🎧")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Brand.textPrimary)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(categories) { category in
                                    MoodRow(mood: category,
                                            isSelected: category == selectedCategory) {
                                        withAnimation(.easeInOut) {
                                            selectedCategory = (selectedCategory == category) ? nil : category
                                        }
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
                        .padding(.horizontal, 18)

                        // Title
                        HStack {
                            Text(selectedCategory?.title ?? "All Podcasts")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Brand.textPrimary)
                            Spacer()
                            if let selected = selectedCategory {
                                Text("\(selected.emoji) \(selected.title)")
                                    .font(.subheadline)
                                    .foregroundStyle(Brand.textSecondary)
                            }
                        }
                        .padding(.horizontal, 18)

                        // Cards
                        VStack(spacing: 12) {
                            ForEach(filtered) { p in
                                PodcastCard(podcast: p)
                                    .padding(.horizontal, 18)
                            }
                        }

                        Spacer(minLength: 60)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle("Podcasts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews from friend (معدلة ألوان/ستايل بسيط)
private struct MoodRow: View {
    let mood: PodcastsView.Mood
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Brand.primary : Color.gray.opacity(0.35), lineWidth: isSelected ? 3 : 1.5)
                        .frame(width: 28, height: 28)
                    if isSelected {
                        Circle()
                            .fill(Brand.primary)
                            .frame(width: 12, height: 12)
                    }
                }
                Text("\(mood.emoji) \(mood.title)")
                    .foregroundStyle(Brand.textPrimary)
                Spacer()
            }
            .padding(10)
        }
        .buttonStyle(.plain)
    }
}

private struct PodcastCard: View {
    let podcast: PodcastsView.PodcastItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow.opacity(0.3))
                    .frame(width: 56, height: 56)
                Text("56×56")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(podcast.title).font(.system(size: 16, weight: .semibold))
                Text(podcast.author).font(.system(size: 13)).foregroundColor(.gray)
                Text(podcast.short).font(.system(size: 13)).foregroundColor(.black.opacity(0.6)).lineLimit(2)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.03), radius: 6, y: 4)
    }
}
