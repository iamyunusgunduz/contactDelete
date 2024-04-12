//
//  RecycleView.swift
//  ContactEdit
//
//  Created by Yunus Gündüz on 12.04.2024.
//

import SwiftUI
import Contacts
struct RecycleView: View {
    @Environment(\.presentationMode) var presentationMode
    let store = CNContactStore()
    let contactGivenNameKey = "contactGivenNameKey"
    let contactFamilyNameKey = "contactFamilyNameKey"
    let contactNumberKey = "contactNumberKey"
    @State private var arrayGivenName: [String] = []
    @State private var arrayFamilyName: [String] = []
    @State private var arrayContactNumber: [String] = []
    @State private var isDeleteAll: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Geri")
                    
                }.onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                
            }.padding([.horizontal, .top], 8)
                .foregroundStyle(.black)
            
            Spacer().frame(height: 50)
            HStack {
                Spacer()
                Image(systemName: "trash.slash.fill")
                Text("Tümünü temizle ")
                    .bold()
                    .padding(.trailing, 16)
            }.onTapGesture {
                UserDefaults.standard.set([], forKey: contactGivenNameKey)
                UserDefaults.standard.set([], forKey: contactFamilyNameKey)
                UserDefaults.standard.set([], forKey: contactNumberKey)
                isDeleteAll.toggle()
            }
            .fullScreenCover(isPresented: $isDeleteAll, content: {
                HomePage()
           })
            Spacer(minLength: 50)
            
            List {
                ForEach(arrayGivenName.prefix(999).indices, id: \.self) { index in
                    let arrayGivenNameList = arrayGivenName[index]
                    let arrayFamilyNameList = arrayFamilyName[index]
                    let arrayContactNumberList = arrayContactNumber[index]
                    
                    if arrayGivenName.count > 0{
                        HStack(spacing: 30) {
                            VStack (alignment: .leading) {
                                Text("\(arrayGivenNameList)  \(arrayFamilyNameList)")
                                Text("\(arrayContactNumberList)").bold()
                            }
                      
                            Spacer()
                            VStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32, alignment: .trailing)
                                    .foregroundStyle(.green)
                            }.onTapGesture {
                                
                                let newContact = CNMutableContact()
                                newContact.givenName = "\(arrayGivenNameList)"
                                newContact.familyName = "\(arrayFamilyNameList)"

                                // Yeni bir telefon numarası ekleyin.
                                let newPhoneNumber = CNPhoneNumber(stringValue: "\(arrayContactNumberList)")
                                let phoneNumberLabel = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: newPhoneNumber)
                                newContact.phoneNumbers = [phoneNumberLabel]

                                // Kişiyi kaydedin.
                                let saveRequest = CNSaveRequest()
                                saveRequest.add(newContact, toContainerWithIdentifier: nil)

                                do {
                                    try store.execute(saveRequest)
                                    print("Yeni kişi ve numara başarıyla kaydedildi.")
                                    arrayGivenName.remove(at: index)
                                    arrayFamilyName.remove(at: index)
                                    arrayContactNumber.remove(at: index)
                                  
                                  UserDefaults.standard.set(arrayGivenName, forKey: contactGivenNameKey)
                                  UserDefaults.standard.set(arrayFamilyName, forKey: contactFamilyNameKey)
                                  UserDefaults.standard.set(arrayContactNumber, forKey: contactNumberKey)
                                  
                                  arrayGivenName = UserDefaults.standard.stringArray(forKey: contactGivenNameKey) ?? []
                                  arrayFamilyName = UserDefaults.standard.stringArray(forKey: contactFamilyNameKey) ?? []
                                  arrayContactNumber = UserDefaults.standard.stringArray(forKey: contactNumberKey) ?? []
                                } catch {
                                    print("Kişi kaydetme başarısız oldu, hata: \(error)")
                                    // Hata ile ilgilenin.
                                }
                            }
                            
                            VStack {
                                Image(systemName: "trash.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32, alignment: .leading)
                                    .foregroundStyle(.red)
                            }.onTapGesture {
                                  arrayGivenName.remove(at: index)
                                  arrayFamilyName.remove(at: index)
                                  arrayContactNumber.remove(at: index)
                                
                                UserDefaults.standard.set(arrayGivenName, forKey: contactGivenNameKey)
                                UserDefaults.standard.set(arrayFamilyName, forKey: contactFamilyNameKey)
                                UserDefaults.standard.set(arrayContactNumber, forKey: contactNumberKey)
                                
                                arrayGivenName = UserDefaults.standard.stringArray(forKey: contactGivenNameKey) ?? []
                                arrayFamilyName = UserDefaults.standard.stringArray(forKey: contactFamilyNameKey) ?? []
                                arrayContactNumber = UserDefaults.standard.stringArray(forKey: contactNumberKey) ?? []
                            }
                            
                           
                        }
                    }
                }
            }
            
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        .onAppear {
            arrayGivenName = UserDefaults.standard.stringArray(forKey: contactGivenNameKey) ?? []
            arrayFamilyName = UserDefaults.standard.stringArray(forKey: contactFamilyNameKey) ?? []
            arrayContactNumber = UserDefaults.standard.stringArray(forKey: contactNumberKey) ?? []
        }
        
    }
}
