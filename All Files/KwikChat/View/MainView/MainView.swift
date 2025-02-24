//
//  MainView.swift
//  KwikChat
//
//  Created by Abuzar Siddiqi on 2/23/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MArk: TabView With Recent Post and Profile Tabs
        TabView{
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(.black)
        // Mark: Changing Tab Lable Tint to Black
        
    }
}

#Preview {
    MainView()
}
