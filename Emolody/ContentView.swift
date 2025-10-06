//
//  ContentView.swift
//  emolody2
//
//  Created by toleen alghamdi on 04/04/1447 AH.
//
import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let titleSize = max(44, width * 0.13)
            let noteSize = titleSize * 0.55
            let subtitleSize = max(14, width * 0.035)

            ZStack {
                // خلفية متدرجة
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "F0E7FF"),
                        Color(hex: "EAD8FF")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer(minLength: geo.size.height * 0.22)

                    // Emolody + نوتة موسيقية
                    HStack(alignment: .bottom, spacing: 6) {
                        Text("Emo")
                            .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "9B7BFF"))

                        Text("lody")
                            .font(.system(size: titleSize, weight: .black, design: .rounded))
                            .foregroundColor(.black)

                        Image(systemName: "music.note")
                            .font(.system(size: noteSize, weight: .regular))
                            .baselineOffset(-noteSize * 0.12)
                            .foregroundStyle(Color(hex: "9B7BFF"))
                            .opacity(0.95)
                    }
                    .fixedSize()
                    .padding(.horizontal)

                    Text("Feel your mood. Hear your world.")
                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
                        .foregroundColor(Color(.sRGB, red: 0.28, green: 0.28, blue: 0.28, opacity: 1))
                        .padding(.top, 4)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// مساعد ألوان من hex
extension Color {
    init(hex: String) {
        var hexSan = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSan.hasPrefix("#") { hexSan.removeFirst() }

        var int: UInt64 = 0
        Scanner(string: hexSan).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hexSan.count {
        case 6:
            r = (int >> 16) & 0xFF
            g = (int >> 8) & 0xFF
            b = int & 0xFF
        default:
            r = 0; g = 0; b = 0
        }
        self.init(.sRGB,
                  red: Double(r)/255.0,
                  green: Double(g)/255.0,
                  blue: Double(b)/255.0,
                  opacity: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 17 Pro")
            ContentView().previewDevice("iPhone SE (3rd generation)")
        }
    }
}

