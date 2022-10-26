//
//  RegistrationModel.swift
//  myChat
//
//  Created by Мария Хатунцева on 22.10.2022.
//

struct RegistrationModel {
    var nickname: String
    var email: String
    var password: String
}

struct ResponseCode {
    var code: Int
}

enum AuthResponse {
    case isVerified, isRegistered, isUnknown
}
