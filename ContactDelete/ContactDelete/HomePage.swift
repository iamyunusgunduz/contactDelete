//
//  HomePage.swift
//  ContactEdit
//
//  Created by Yunus Gündüz on 12.04.2024.
//

import SwiftUI

struct HomePage: View {
    @State var isDeletePagePresent = false
    @State var isRecycleViewPresent = false
    
    let contactGivenNameKey = "contactGivenNameKey"
    let contactFamilyNameKey = "contactFamilyNameKey"
    let contactNumberKey = "contactNumberKey"
    @State private var arrayGivenName: [String] = []
    @State private var arrayFamilyName: [String] = []
    @State private var arrayContactNumber: [String] = []
    
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer().frame(height: 30)
            VStack {
                Text("Kişilerimi sil uygulaması")
                    .font(.largeTitle)
            }
            
            VStack {
                
                Image(systemName: "list.bullet.rectangle.portrait")
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        isDeletePagePresent.toggle()
                    }
                    .fullScreenCover(isPresented: $isDeletePagePresent, content: {
                       DeleteContact()
                   })
                    
                Text("Kişilerimi Listele").bold()
             
            }
            
            VStack {
                Image(systemName: "person.crop.circle.badge.clock")
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        isRecycleViewPresent.toggle()
                    }
                    .fullScreenCover(isPresented: $isRecycleViewPresent, content: {
                        RecycleView()
                   })
                Text("Geçmiş").bold()
            }
            
            Spacer(minLength: 50)
        }
        .padding(8)
        .textCase(.uppercase)
        .foregroundStyle(.black)
    }
}
