//
//  AllSamplesView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 04/12/2023.
//

import SwiftUI

struct AllSamplesView: View {
    
    var selectedIssue: Int?
    @StateObject private var viewModel = AllSamplesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 10) {
                if !viewModel.issues.isEmpty {
                  
                    
                    ForEach(0..<viewModel.issues[selectedIssue!].superset, id: \.self) { sample in
                        let intSmap = Int(sample)
                        NavigationLink(destination: SampleView(issueName: viewModel.issues[selectedIssue!].name!, sampleNumber: intSmap)) {
                            RoundedRectangle(cornerRadius: 10).fill(viewModel.getRectangleColour(subset: Int(viewModel.issues[selectedIssue!].subset), sample: intSmap))
                                .frame(width: 300, height: 150)
                                .overlay(
                                    VStack {
                                        if !viewModel.isBestSubSample.isEmpty && intSmap  {
                                            if viewModel.isBestSubSample[intSmap] {
                                                Image(systemName: "star.fill").padding()
                                            }
                                        }
                                        Text("\(viewModel.issues[selectedIssue!].name!): \(viewModel.getSetName(subset: Int(viewModel.issues[selectedIssue!].subset), sample: intSmap)) \(intSmap + 1)")
                                        if !viewModel.sampleNames.isEmpty {
                                            Text(viewModel.sampleNames[intSmap])
                                        }
                                        if !viewModel.sampleOverallScores.isEmpty {
                                            Text("Overall Rating: \(viewModel.sampleOverallScores[intSmap])")
                                        }
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
            viewModel.loadIssues(selectedIssue!)
        }
        .background(.white)
    }
}

//struct AllSamplesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllSamplesView()
//    }
//}
