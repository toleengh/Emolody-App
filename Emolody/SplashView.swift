//
//  SplashView.swift
//  Emolody
//
//  Created by toleen alghamdi on 14/04/1447 AH.
//

import SwiftUI

struct SplashView: View {
    /// يستدعى تلقائيًا بعد انتهاء الأنيميشن
    var onFinished: () -> Void

    @State private var revealIndex = 0        // كم حرف ظاهر الآن
    @State private var showNote = false       // ظهور النوتة 🎵 تدريجيًا

    // نص الشعار مقسّم: "Emo" بنفسجي + "lody" أسود
    private let emo = Array("Emo")
    private let lody = Array("lody")

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let titleSize = max(44, width * 0.13)
            let noteSize = titleSize * 0.55
            let subtitleSize = max(14, width * 0.035)

            ZStack {
                // الخلفية بنفس التدرّج المطلوب (بدون أي extensions)
                LinearGradient(
                    colors: [
                        Color(red: 240/255, green: 231/255, blue: 1.0), // F0E7FF
                        Color(red: 234/255, green: 216/255, blue: 1.0)  // EAD8FF
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer(minLength: geo.size.height * 0.22)

                    // الشعار حرف-حرف
                    HStack(alignment: .bottom, spacing: 6) {
                        HStack(spacing: 0) {
                            ForEach(0..<emo.count, id: \.self) { i in
                                Text(String(emo[i]))
                                    .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(red: 155/255, green: 123/255, blue: 1.0)) // 9B7BFF
                                    .opacity(revealIndex > i ? 1 : 0)
                            }
                        }

                        HStack(spacing: 0) {
                            ForEach(0..<lody.count, id: \.self) { i in
                                Text(String(lody[i]))
                                    .font(.system(size: titleSize, weight: .black, design: .rounded))
                                    .foregroundColor(.black)
                                    .opacity(revealIndex > emo.count + i ? 1 : 0)
                            }
                        }

                        Image(systemName: "music.note")
                            .font(.system(size: noteSize, weight: .regular))
                            .baselineOffset(-noteSize * 0.12)
                            .foregroundColor(Color(red: 155/255, green: 123/255, blue: 1.0))
                            .opacity(showNote ? 0.95 : 0)
                    }
                    .fixedSize()
                    .padding(.horizontal)

                    Text("Feel your mood. Hear your world.")
                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
                        .foregroundColor(Color(.sRGB, red: 0.28, green: 0.28, blue: 0.28, opacity: 1))
                        .opacity(showNote ? 1 : 0)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                runAnimation()
            }
        }
    }

    private func runAnimation() {
        let totalChars = emo.count + lody.count
        // إظهار كل حرف بفاصل زمني صغير
        for i in 0...totalChars {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16 * Double(i)) {
                withAnimation(.easeOut(duration: 0.18)) {
                    revealIndex = i + 1
                }
                // بعد آخر حرف، أظهر النوتة ثم انتقل
                if i == totalChars {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            showNote = true
                        }
                        // مهلة قصيرة ثم الانتقال
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            onFinished()
                        }
                    }
                }
            }
        }
    }
}
