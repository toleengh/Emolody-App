//
//  VerifyNumber.swift
//  emolody2
//
//  Created by toleen alghamdi on 07/04/1447 AH.
//
import SwiftUI

/// شاشة إدخال رمز OTP.
/// ملاحظات للمطوّر: ابحث عن // OTP: للتعليقات الخاصة بالربط الحقيقي.
struct VerifyNumberView: View {
    let phoneNumber: String
    var onVerified: () -> Void

    @State private var code: String = ""
    @State private var timeRemaining = 59
    @State private var timerActive = true
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    /// لتجربة الفلو بدون باك-إند. عطّليها عند الربط الحقيقي.
    private let DEV_BYPASS_OTP = true

    var body: some View {
        ZStack {
            AppScreenBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 60)

                // الشعار
                HStack(alignment: .bottom, spacing: 6) {
                    Text("Emo").font(.system(size: 42, weight: .semibold, design: .rounded)).foregroundColor(Brand.primary)
                    Text("lody").font(.system(size: 42, weight: .black, design: .rounded)).foregroundColor(.black)
                    Image(systemName: "music.note").font(.system(size: 24)).foregroundColor(Brand.primary).baselineOffset(-4)
                }

                Text("Verification Code").font(.system(size: 18, weight: .semibold))
                Text("Enter the 6-digit code sent to \(phoneNumber)")
                    .font(.system(size: 14)).foregroundColor(.gray)

                // الحقل
                TextField("000000", text: $code)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .frame(maxWidth: 260)
                    .onChange(of: code) { new in
                        let filtered = new.filter { "0123456789".contains($0) }
                        code = String(filtered.prefix(6))
                    }

                if let error = errorMessage {
                    Text(error).foregroundStyle(.red).font(.footnote)
                }

                // مؤقّت إعادة الإرسال
                if timerActive {
                    Text("Resend code in \(timeRemaining)s")
                        .font(.system(size: 14)).foregroundColor(.gray)
                } else {
                    Button("Resend Code") { resendCode() }
                        .foregroundColor(Brand.primary)
                }

                // زر التحقق
                Button {
                    verifyTapped()
                } label: {
                    HStack(spacing: 8) {
                        if isSubmitting { ProgressView().tint(.white) }
                        Text("Verify Code")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isVerifyEnabled ? Brand.primary : Brand.primary.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .frame(maxWidth: 260)
                .disabled(!isVerifyEnabled || isSubmitting)

                Spacer()
            }
            .padding()
        }
        .onAppear(perform: startTimer)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - OTP helpers

    /// الزر مفعّل إذا 6 أرقام *أو* وضع المطوّر مفعّل.
    private var isVerifyEnabled: Bool {
        DEV_BYPASS_OTP || code.count == 6
    }

    private func startTimer() {
        timeRemaining = 59
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeRemaining > 0 { timeRemaining -= 1 }
            else { t.invalidate(); timerActive = false }
        }
    }

    private func resendCode() {
        // OTP: هنا تربط زر إعادة الإرسال مع مزود الـ OTP (Firebase/خادمك).
        // أعد تشغيل المؤقت فقط كتجربة UI:
        startTimer()
    }

    private func verifyTapped() {
        // OTP: إن ربطتَ Backend، بدّل هذا المنطق باستدعاء التحقق الحقيقي.
        if DEV_BYPASS_OTP {
            onVerified()
            return
        }

        guard code.count == 6 else { return }
        isSubmitting = true
        errorMessage = nil

        // محاكاة تحقق شبكي:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSubmitting = false
            let success = true // ← غيّر حسب نتيجة الخادم
            if success { onVerified() }
            else { errorMessage = "Invalid code. Try again." }
        }
    }
}
