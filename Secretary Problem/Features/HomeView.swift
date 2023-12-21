//
//  HomeView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 21/11/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Secretary Problem").padding(EdgeInsets(top: 50, leading: 0, bottom: 20, trailing: 0)).font(Font.system(size: 40))
                Text("Calculate the ultimate stopping point to help you make any life decision.")
                Spacer()
                NavigationLink(destination: CreateNewIssueView()) {
                    Text("Create New Issue").padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                }
                NavigationLink(destination: MyIssues()) {
                    Text("My Issues").padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                }
                NavigationLink(destination: HowItWorksView()) {
                    Text("How it Works").padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                }
            }.foregroundColor(.blue)
                .background(.green)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
