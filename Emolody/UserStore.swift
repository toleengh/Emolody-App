//
//  UserStore.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI
import Combine

/// يخزن بيانات المستخدم الأساسية (محفوظة محليًا)
final class UserStore: ObservableObject {
    // اسم المستخدم
    @AppStorage("user.name") var storedName: String = ""
    @Published var name: String = ""

    // آخر مود محفوظ (لإظهار آخر نتيجة في Home)
    @AppStorage("user.lastMood") var storedLastMood: String = ""
    @Published var lastMood: String = ""

    // التفضيلات الأساسية (أصناف + أنشطة)
    @AppStorage("user.genres") private var storedGenres: String = "" // CSV
    @Published var genres: Set<String> = []

    @AppStorage("user.activities") private var storedActivities: String = "" // CSV
    @Published var activities: Set<String> = []

    init() {
        // مزامنة من التخزين
        name = storedName
        lastMood = storedLastMood
        genres = Set(storedGenres.split(separator: ",").map { String($0) })
        activities = Set(storedActivities.split(separator: ",").map { String($0) })
    }

    func save() {
        storedName = name
        storedLastMood = lastMood
        storedGenres = genres.joined(separator: ",")
        storedActivities = activities.joined(separator: ",")
    }
}
