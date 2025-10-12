//
//  UserStore.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//
import SwiftUI
import Combine

final class UserStore: ObservableObject {
    // اسم المستخدم
    @AppStorage("user.name") private var storedName: String = ""
    @Published var name: String = ""

    // رقم الهاتف
    @AppStorage("user.phone") private var storedPhone: String = ""
    @Published var phone: String = ""

    // آخر مود محفوظ
    @AppStorage("user.lastMood") private var storedLastMood: String = ""
    @Published var lastMood: String = ""

    // التفضيلات
    @AppStorage("user.genres") private var storedGenres: String = "" // CSV
    @Published var genres: Set<String> = []

    @AppStorage("user.activities") private var storedActivities: String = "" // CSV
    @Published var activities: Set<String> = []

    init() {
        name = storedName
        phone = storedPhone
        lastMood = storedLastMood
        genres = Set(storedGenres.split(separator: ",").map { String($0) })
        activities = Set(storedActivities.split(separator: ",").map { String($0) })
    }

    func save() {
        storedName = name
        storedPhone = phone
        storedLastMood = lastMood
        storedGenres = genres.joined(separator: ",")
        storedActivities = activities.joined(separator: ",")
    }

    func clear() {
        name = ""
        phone = ""
        lastMood = ""
        genres.removeAll()
        activities.removeAll()
        save()
    }
}
