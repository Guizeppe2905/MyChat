//
//  UserSettings.swift
//  myChat
//
//  Created by Мария Хатунцева on 28.10.2022.
//

import Foundation
import FirebaseAuth

class UserSettings: ObservableObject {
    static let shared = UserSettings()
 
    @Published var myselfAva: [String?: String] {
        didSet {
            UserDefaults.standard.set(myselfAva, forKey: "myselfAva")
        }
    }
  

    init() {
       
        self.myselfAva = UserDefaults.standard.object(forKey: "myselfAva") as? [String: String] ?? [Auth.auth().currentUser?.uid : "ava1"]

    }
}

