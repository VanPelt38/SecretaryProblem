//
//  AllSamplesView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 04/12/2023.
//

import SwiftUI

struct AllSamplesView: View {
    
    var selectedIssue: Int?
    @StateObject private var viewModel = MyIssuesViewModel()
    @StateObject private var ownViewModel = AllSamplesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 10) {
                if !viewModel.issues.isEmpty {
                    ForEach(0..<viewModel.issues[selectedIssue!].superset, id: \.self) { sample in
                        
                        NavigationLink(destination: SampleView(issueName: viewModel.issues[selectedIssue!].name!)) {
                            RoundedRectangle(cornerRadius: 10).fill(ownViewModel.getRectangleColour(subset: Int(viewModel.issues[selectedIssue!].subset), sample: Int(sample)))
                                .frame(width: 300, height: 150)
                                .overlay(
                                    VStack {
                                        
                                        Text("\(viewModel.issues[selectedIssue!].name!): \(ownViewModel.getSetName(subset: Int(viewModel.issues[selectedIssue!].subset), sample: Int(sample))) Sample \(sample + 1)")
                                        Text("Overall Rating:")
                                    }.foregroundColor(.black)
                                )
                            
                                .padding()
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            .padding()
        }
        .onAppear {
            viewModel.loadIssues()
        }
        .background(.white)
    }
}

//struct AllSamplesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllSamplesView()
//    }
//}
