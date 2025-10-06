//
//  VerifyNumber.swift
//  emolody2
//
//  Created by toleen alghamdi on 07/04/1447 AH.
//

import SwiftUI

struct VerifyNumberView: View {
    let phoneNumber: String
    var onVerified: () -> Void

    @State private var code: String = ""

    var body: some View {
        ZStack {
            ScreenBackground()

            VStack(spacing: 24) {
                Text("We sent a code to:")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(phoneNumber)
                    .font(.title3).bold()

                TextField("Enter 6-digit code", text: $code)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onChange(of: code) { newValue in
                        code = String(newValue.prefix(6))
                    }

                Button("Verify") { onVerified() }
                    .disabled(code.count < 6)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(code.count < 6 ? Brand.primary.opacity(0.3) : Brand.primary)
                    .cornerRadius(12)

                Button("Resend code") { }
                    .foregroundStyle(Brand.primary)

                Spacer()
            }
            .padding()
            .navigationTitle("Verify Number")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
