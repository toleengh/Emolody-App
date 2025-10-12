//
//  SplashView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//
import SwiftUI

/// شاشة الترحيب (الشعار). تبقى ثانيتين ثم تنتقل تلقائيًا لخطوة إدخال الرقم.
struct SplashView: View {
    var onFinished: () -> Void    // يستدعى بعد ثانيتين

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let titleSize = max(44, width * 0.13)
            let noteSize  = titleSize * 0.55
            let subtitleSize = max(14, width * 0.035)

            ZStack {
                // نفس تدرّج ألوان صاحبتك (بدون Color(hex:) لتجنّب التعارض)
                LinearGradient(
                    colors: [
                        Color(red: 240/255, green: 231/255, blue: 1.00), // F0E7FF
                        Color(red: 234/255, green: 216/255, blue: 1.00)  // EAD8FF
                    ],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer(minLength: geo.size.height * 0.22)

                    HStack(alignment: .bottom, spacing: 6) {
                        Text("Emo")
                            .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 155/255, green: 123/255, blue: 1.0)) // 9B7BFF

                        Text("lody")
                            .font(.system(size: titleSize, weight: .black, design: .rounded))
                            .foregroundColor(.black)

                        Image(systemName: "music.note")
                            .font(.system(size: noteSize, weight: .regular))
                            .baselineOffset(-noteSize * 0.12)
                            .foregroundStyle(Color(red: 155/255, green: 123/255, blue: 1.0))
                            .opacity(0.95)
                    }
                    .fixedSize()
                    .padding(.horizontal)

                    Text("Feel your mood. Hear your world.")
                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
                        .foregroundColor(Color(.sRGB, red: 0.28, green: 0.28, blue: 0.28, opacity: 1))

                    Spacer()
                }
            }
        }
        .onAppear {
            // بعد ثانيتين ننتقل لصفحة إدخال الرقم
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                onFinished()
            }
        }
    }
}
