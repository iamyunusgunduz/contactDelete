//
//  ContactDeleteApp.swift
//  ContactDelete
//
//  Created by Yunus Gündüz on 12.04.2024.
//

import SwiftUI

@main
struct ContactDeleteApp: App {
    
     init() {
         if UserDefaults.standard.string(forKey: "projectLanguage") != nil {return}
         let deviceLanguage = Locale.preferredLanguages.first
         print("Cihazın dil ayarı: \(deviceLanguage ?? "Bilinmiyor")")
         if let lang  = deviceLanguage {
             if lang.contains("tr-") {
                 UserDefaults.standard.setValue("tr", forKey: "projectLanguage")
             }
            else if lang.contains("en-") {
                 UserDefaults.standard.setValue("en", forKey: "projectLanguage")
             }
             else {
                 UserDefaults.standard.setValue("en", forKey: "projectLanguage")
             }
         } else {
             UserDefaults.standard.setValue("en", forKey: "projectLanguage")
         }
     }
    
    var body: some Scene {
        WindowGroup {
            HomePage()
        }
        
    }
}
