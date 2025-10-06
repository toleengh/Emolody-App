//
//  enterphonnumber.swift
//  emolody2
//
//  Created by toleen alghamdi on 07/04/1447 AH.
//
import SwiftUI

struct EnterPhoneNumberView: View {
    @State private var phoneNumber: String = ""
    var onContinue: (String) -> Void

    var body: some View {
        ZStack {
            ScreenBackground()

            VStack(spacing: 20) {
                // الشعار البسيط
                HStack {
                    Text("Emo").foregroundColor(Brand.primary)
                    + Text("lody").foregroundColor(Brand.textPrimary)
                    Image(systemName: "music.note")
                        .foregroundColor(Brand.primary)
                }
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 24)

                // إدخال رقم الهاتف
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.headline)
                        .foregroundStyle(Brand.textPrimary)

                    TextField("Enter your phone number", text: $phoneNumber)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.phonePad)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)

                // متابعة
                Button {
                    onContinue(phoneNumber)
                } label: {
                    Text("Continue with Phone")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Brand.primary.opacity(phoneNumber.isEmpty ? 0.3 : 1))
                        .cornerRadius(10)
                }
                .disabled(phoneNumber.isEmpty)

                // فواصل
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("or continue with")
                        .foregroundColor(.gray).font(.subheadline)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                .padding(.vertical, 10)

                // زرّان (Placeholder)
                Button("Continue with Spotify") { }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)

                Button("Continue with Apple Music") { }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                Spacer()
            }
            .padding()
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
