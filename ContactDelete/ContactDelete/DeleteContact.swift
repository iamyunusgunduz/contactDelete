//
//  DeleteContact.swift
//  
//
//  Created by Yunus Gündüz on 12.04.2024.
//
import SwiftUI
import Contacts

struct DeleteContact: View {
    @State var contacts = [CNContact]()
    @State var isPresent: Bool =  false
    @State private var selectedContact: CNContact?
    @Environment(\.presentationMode) var presentationMode
    let contactGivenNameKey = "contactGivenNameKey"
    let contactFamilyNameKey = "contactFamilyNameKey"
    let contactNumberKey = "contactNumberKey"
    @State private var arrayGivenName: [String] = []
    @State private var arrayFamilyName: [String] = []
    @State private var arrayContactNumber: [String] = []
    @State var projectLanguage: String = "en"
 
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text(projectLanguage == "en" ? "back" : "geri")
                }.onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                HStack {
                    Text(projectLanguage == "en" ? "Contact List" : "Kişi Listesi").bold()
                    Text("\(contacts.count)").bold()
                }.padding(.trailing, 4)
                
             
            }.padding([.horizontal, .top], 8)
                .foregroundStyle(.black)
           
            List {
                ForEach(contacts.prefix(999).indices, id: \.self) { index in
                    let user = contacts[index]
                    
                    if user.phoneNumbers.count > 0{
                        HStack {
                            
                        
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    if (user.givenName.count > 0) {
                                        Text(String(user.givenName.prefix(1).uppercased())).font(.title)
                                            .foregroundStyle(.gray)
                                            .opacity(0.3)
                                    }
                                    
                                    
                                    if (user.givenName.count > 0) {
                                        HStack{
                                            Text("\(user.givenName) ")
                                            Text("\(user.familyName) ").bold()
                                        }
                                    }
                                }
                                if (user.namePrefix.count > 0) {
                                    HStack{
                                        Text("\(user.namePrefix) ")
                                        Text("\(user.nameSuffix) ")
                                    }
                                }
                                if (user.middleName.count > 0) {
                                    HStack{
                                        Text("\(user.middleName) ")
                                    }
                                }
                               
//                                    VStack {
//                                        ForEach(user.socialProfiles, id: \.identifier) { labeledProfile in
//                                                HStack {
//                                                    Text("\(labeledProfile.value.username) \(labeledProfile.value.service) \(labeledProfile.value.urlString) \(labeledProfile.value.userIdentifier) ")
//                                                        .bold()
//                                                        .background(.green)
//                                                }
//
//                                        }
//                                    }
                               
                                   
                                if (user.phoneNumbers.count > 0) {
                                    VStack {
                                        ForEach(user.phoneNumbers.indices, id: \.self) { phoneNumberIndex in
                                            let numara = user.phoneNumbers[phoneNumberIndex].value.stringValue
                                            HStack {
                                                
                                                Text("\(numara)").font(.title3)
                                            }
                                          
                                        }
                                    }
                                }
                                
                                if (user.nickname.count > 0) {
                                    HStack{
                                        Text("\(user.nickname) ")
                                    }
                                }
                                if (user.phoneticGivenName.count > 0) {
                                    HStack{
                                        Text("\(user.phoneticGivenName) ")
                                    }
                                }
                                if (user.phoneticMiddleName.count > 0) {
                                    HStack{
                                        Text("\(user.phoneticMiddleName) ")
                                    }
                                }
                                if (user.phoneticFamilyName.count > 0) {
                                    HStack{
                                        Text("\(user.phoneticFamilyName) ")
                                    }
                                }
                                
                            }.onTapGesture {
                                print("Tıklanan kişi: \(index + 1) \(user.givenName) \(user.familyName)")
                            }.fullScreenCover(isPresented: $isPresent) {
                                EmptyView()
                            }
                            
                            Spacer()
                            VStack {
                                
                                Image(systemName: "trash.square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .trailing)
                                    .foregroundStyle(.red)
                                
                                
                            }.onTapGesture {
                                
                                deleteContact(contact: user)
                                print("silinenn kişi: \(user.givenName)")
                                
                                arrayGivenName = UserDefaults.standard.stringArray(forKey: contactGivenNameKey) ?? []
                                arrayFamilyName = UserDefaults.standard.stringArray(forKey: contactFamilyNameKey) ?? []
                                arrayContactNumber = UserDefaults.standard.stringArray(forKey: contactNumberKey) ?? []
                                
                                arrayGivenName.append("\(user.givenName)")
                                arrayFamilyName.append("\(user.familyName)")
                                arrayContactNumber.append("\(user.phoneNumbers[0].value.stringValue)")
                                
                                UserDefaults.standard.set(arrayGivenName, forKey: contactGivenNameKey)
                                UserDefaults.standard.set(arrayFamilyName, forKey: contactFamilyNameKey)
                                UserDefaults.standard.set(arrayContactNumber, forKey: contactNumberKey)
 
                               
                               
                                contacts.removeAll()
                                getContactList()
                                
                            }
                            
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .onAppear(perform: getContactList)
            
            
        }
    }
  
 
    
    func getContactList() {
        DispatchQueue.global().async {
        let CNStore = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            do {
                let keys = [
                    CNContactGivenNameKey as  CNKeyDescriptor,
                    CNContactMiddleNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    
                    CNContactNamePrefixKey as CNKeyDescriptor,
                    CNContactNameSuffixKey as CNKeyDescriptor,
                    
                    CNContactNicknameKey as CNKeyDescriptor,
                    CNContactPhoneticGivenNameKey as CNKeyDescriptor,
                    CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
                    CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
                    
                    CNContactImageDataKey as CNKeyDescriptor,
                    CNContactImageDataAvailableKey as CNKeyDescriptor,
                    CNContactThumbnailImageDataKey as CNKeyDescriptor,
                    
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                    CNContactSocialProfilesKey as CNKeyDescriptor
                ]
                let request = CNContactFetchRequest(keysToFetch: keys)
                request.sortOrder = CNContactSortOrder.userDefault
                try CNStore.enumerateContacts(with: request) { contact, _ in
                    contacts.append(contact)
                }
            }catch {
                print("Hata kisiler getirilemedi \(error)")
            }
        case .denied:
            print("denied")
        case .notDetermined:
            CNStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    getContactList()
                } else if let error = error {
                    print("Error requesting contact access \(error)")
                }
            }
        case .restricted:
            print("restricted")
        @unknown default:
            print("!-!")
        }
    }
    }
    
//    func deleteNumber(contact: CNContact, phoneNumberIndex: Int) {
//        let store = CNContactStore()
//        let contactMutable = contact.mutableCopy() as! CNMutableContact
//
//        contactMutable.phoneNumbers.remove(at: phoneNumberIndex)
//
//        let saveRequest = CNSaveRequest()
//        saveRequest.update(contactMutable)
//
//        do {
//            try store.execute(saveRequest)
//            print("Phone number deleted successfully.")
//        } catch {
//            print("Error deleting phone number: \(error)")
//        }
//    }
    
    func deleteContact(contact: CNContact) {
        let store = CNContactStore()
        let contactMutable = contact.mutableCopy() as! CNMutableContact
        
        let saveRequest = CNSaveRequest()
        saveRequest.delete(contactMutable)
        do {
            try store.execute(saveRequest)
            print("Contact deleted successfully.")
        } catch {
            print("Error deleting contact: \(error)")
        }
    }
    
    
}
