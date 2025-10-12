//
//  OnboardingProfileView.swift
//  Emolody
//
//  Created by toleen alghamdi on 20/04/1447 AH.
//

import SwiftUI

/// صفحة واحدة تجمع: إدخال الاسم + اختيار الاهتمامات.
/// بعد الحفظ تنتقلين للـ Home (Main Tabs).
struct OnboardingProfileView: View {
    @ObservedObject var user: UserStore
    var onDone: () -> Void

    @State private var name: String = ""

    // خيارات قابلة للتعديل
    private let allGenres = ["Pop", "Hip-Hop", "R&B", "EDM", "Chill", "Classical", "Rock", "Jazz"]
    private let allActivities = ["Workout", "Study", "Commute", "Relax", "Party", "Reading"]

    var body: some View {
        ZStack {
            ScreenBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Complete your profile")
                        .font(.title2.bold())
                        .foregroundStyle(Brand.textPrimary)

                    // الاسم
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your name")
                            .font(.headline)
                            .foregroundStyle(Brand.textPrimary)

                        TextField("Enter your name", text: $name)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    // الأنواع الموسيقية
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Favorite genres")
                            .font(.headline)
                            .foregroundStyle(Brand.textPrimary)

                        FlowWrap(allGenres, id: \.self) { tag in
                            SelectChip(title: tag, isSelected: user.genres.contains(tag)) {
                                toggle(&user.genres, tag)
                            }
                        }
                    }

                    // الأنشطة
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Activities")
                            .font(.headline)
                            .foregroundStyle(Brand.textPrimary)

                        FlowWrap(allActivities, id: \.self) { tag in
                            SelectChip(title: tag, isSelected: user.activities.contains(tag)) {
                                toggle(&user.activities, tag)
                            }
                        }
                    }

                    Button {
                        user.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        user.save()
                        onDone()
                    } label: {
                        Text("Save & continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Brand.primary.opacity(0.35) : Brand.primary)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .padding(.top, 6)
                }
                .padding()
            }
        }
        .onAppear { name = user.name }
        .navigationTitle("Profile setup")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ set: inout Set<String>, _ item: String) {
        if set.contains(item) { set.remove(item) } else { set.insert(item) }
    }
}

// نفس الـ Chip والـ FlowWrap لكن داخل هذا الملف لتقليل عدد الملفات
private struct SelectChip: View {
    let title: String
    let isSelected: Bool
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Brand.primary : Color.white)
                .foregroundStyle(isSelected ? .white : Brand.textPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isSelected ? Brand.primary : Color.gray.opacity(0.25), lineWidth: 1)
                )
                .cornerRadius(18)
                .shadow(color: .black.opacity(isSelected ? 0.08 : 0.03), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }
}

private struct FlowWrap<Data: RandomAccessCollection, Content: View, ID: Hashable>: View {
    var data: Data
    var id: KeyPath<Data.Element, ID>
    var content: (Data.Element) -> Content

    init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data; self.id = id; self.content = content
    }

    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(data, id: id) { item in
                    content(item)
                        .padding(.trailing, 8)
                        .padding(.bottom, 8)
                        .alignmentGuide(.leading) { d in
                            if (abs(width - d.width) > geo.size.width) { width = 0; height -= d.height }
                            let result = width
                            if item[keyPath: id] == data.last?[keyPath: id] { width = 0 } else { width -= d.width }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item[keyPath: id] == data.last?[keyPath: id] { height = 0 }
                            return result
                        }
                }
            }
        }
        .frame(minHeight: 44)
    }
}
