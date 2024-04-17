//
//  HomePage.swift
//  ContactEdit
//
//  Created by Yunus Gündüz on 12.04.2024.
//

import SwiftUI
import Contacts

struct HomePage: View {
    @State var isDeletePagePresent = false
    @State var isRecycleViewPresent = false
    @State private var isContactsPermissionGranted = false
    
    let contactGivenNameKey = "contactGivenNameKey"
    let contactFamilyNameKey = "contactFamilyNameKey"
    let contactNumberKey = "contactNumberKey"
    @State private var arrayGivenName: [String] = []
    @State private var arrayFamilyName: [String] = []
    @State private var arrayContactNumber: [String] = []
    @State private var projectLanguage = UserDefaults.standard.string(forKey: "projectLanguage")
    
    var body: some View {
        VStack {
            if isContactsPermissionGranted {
                VStack(spacing: 30) {
                    HStack {
                        Spacer()
                        Text(projectLanguage  == "en" ? "en" : "tr").textCase(.uppercase)
                            .padding(8)
                            .border(Color.black)
                            .onTapGesture {
                                if projectLanguage == "en" {
                                    UserDefaults.standard.setValue("tr", forKey: "projectLanguage")
                                    projectLanguage = UserDefaults.standard.string(forKey: "projectLanguage")
                                    
                                }
                                else if projectLanguage == "tr" {
                                    UserDefaults.standard.setValue("en", forKey: "projectLanguage")
                                    projectLanguage = UserDefaults.standard.string(forKey: "projectLanguage")
                                }
                                else {
                                    UserDefaults.standard.setValue("en", forKey: "projectLanguage")
                                    projectLanguage = UserDefaults.standard.string(forKey: "projectLanguage")
                                    
                                }
                                
                                print(projectLanguage ?? "-error-")
                            }
                            .onAppear {
                                print("DEBUG: button open")
                                print("DEBUG: \(String(describing: UserDefaults.standard.string(forKey: "projectLanguage")))")
                                
                            }
                        
                        
                        
                    }
                    Spacer().frame(height: 10)
                    HStack {
                        Spacer()
                        Image(.applogoPDF)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150, alignment: .center)
                        Spacer()
                        
                    }
                    //            HStack {
                    //                Spacer()
                    //                    Text(projectLanguage == "en" ? "Delete my Contact " : "Kişilerimi Sil")
                    //                        .font(.largeTitle)
                    //                Spacer()
                    //            }
                    Spacer().frame(height: 30)
                    VStack {
                        
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                isDeletePagePresent.toggle()
                            }
                            .fullScreenCover(isPresented: $isDeletePagePresent, content: {
                                DeleteContact(projectLanguage: projectLanguage ?? "en")
                                
                            })
                        
                        Text(projectLanguage == "en" ? "List my contact" : "Kişilerimi listele" ).bold()
                        
                    }
                    
                    VStack {
                        Image(systemName: "person.crop.circle.badge.clock")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                isRecycleViewPresent.toggle()
                            }
                            .fullScreenCover(isPresented: $isRecycleViewPresent, content: {
                                let _ =   print("get RecycleView \(String(describing: projectLanguage))")
                                RecycleView(projectLanguage: projectLanguage ?? "en")
                            })
                        Text(projectLanguage == "en" ? "History" : "Geçmiş").bold()
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(8)
                .textCase(.uppercase)
                .foregroundStyle(.black)
            }
            else {
                VStack {
                    Spacer()
                    Button(projectLanguage  == "en" ? "The app requests access to your contacts to manage them." : "Uygulama, kişilerinizi yönetmek için erişim izni talep ediyor.") {
                        requestContactsPermission()
                    }.background(.white)
                        .onAppear {
                            requestContactsPermission()
                        }
             
                }
            }
        }
    }
    private func requestContactsPermission() {
        DispatchQueue.global().async {
            let store = CNContactStore()
            let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
            
            if authorizationStatus == .notDetermined {
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            isContactsPermissionGranted = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            isContactsPermissionGranted = false
                            // İzin reddedildiğinde kullanıcıya bilgi ver
                            print("Kişilere erişim izni reddedildi. Lütfen ayarlardan izin verin.")
                        }
                    }
                }
            } else if authorizationStatus == .denied {
                // Kullanıcı zaten izni reddetti, tekrar izin istemek istiyorsanız buraya bir şeyler yapabilirsiniz.
                print("Kişilere erişim izni reddedildi. Tekrar izin isteme işlemi başlatılıyor.")
                // Tekrar izin isteme işlemi
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            isContactsPermissionGranted = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            isContactsPermissionGranted = false
                            print("Kişilere erişim izni tekrar reddedildi.")
                            
                            openAppSettings()
                        }
                    }
                }
            } else {
                // Zaten izin verildi veya sınırlı izin verildi, burada gerekli işlemleri yapabilirsiniz.
                print("Kişilere erişim izni zaten verilmiş veya sınırlı.")
                isContactsPermissionGranted = true
            }
        }
    }
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, completionHandler: nil)
        }
    }
}
