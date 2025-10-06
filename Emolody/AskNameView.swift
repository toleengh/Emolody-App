//
//  AskNameView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

/// شاشة سؤال الاسم لتخصيص الترحيب في الصفحة الرئيسية.
struct AskNameView: View {
    @ObservedObject var user: UserStore
    var onDone: () -> Void

    @State private var name: String = ""

    var body: some View {
        ZStack {
            ScreenBackground()

            VStack(spacing: 18) {
                Text("What should we call you?")
                    .font(.title2.bold())
                    .foregroundStyle(Brand.textPrimary)

                TextField("Your name", text: $name)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                Button {
                    user.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    user.save()
                    onDone()
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Brand.primary.opacity(0.35) : Brand.primary)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)

                Spacer()
            }
            .padding()
        }
        .onAppear { name = user.name }
        .navigationTitle("Your name")
        .navigationBarTitleDisplayMode(.inline)
    }
}
