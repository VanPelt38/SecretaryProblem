//
//  SampleView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 12/12/2023.
//

import SwiftUI

struct SampleView: View {
    
    @State private var sampleName: String = ""
    @State var issueName: String
    @State var sampleNumber: Int
    @State var overallScore: Int = 0
    @State private var criteriaRatings: [Int] = [1]
    @ObservedObject private var viewModel = SampleViewModel()
    @State private var issueLoaded = false
    @State private var showDismissAlert = false
//    @State private var sampleTextFieldValue = viewModel.currentSample.name
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       
            ScrollView {
                
                VStack {
                    if let issue = viewModel.issue {
                        HStack {
                            Text("Sample Name:").padding()
                            TextField("choose name", text: $viewModel.sampleName).foregroundColor(.black).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        if !issue.isOverallScore {
                            
                            ForEach(0..<(viewModel.criteriaCount), id: \.self) { count in
                                
                                
                                Text("\(count + 1). \(viewModel.criteria[count].name! as String):").padding()
                                if !criteriaRatings.isEmpty {
                                    let _ = print("count: \(criteriaRatings.count)")
                                Picker("", selection: $criteriaRatings[count]) {
                                    ForEach(0...10, id: \.self) {
                                        Text("\($0)")
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                                //                            .onChange(of: selectedWeight) { newValue in
                                //
                                //                        }
                            }
                                
                            }
                        }
                       
                                Text("Overall Score:").padding()
                        Picker("", selection: $viewModel.overallScore) {
                                    ForEach(0...10, id: \.self) {
                                        Text("\($0)")
                                    }
                                }.pickerStyle(WheelPickerStyle())
                            .padding()
                            .disabled(!issue.isOverallScore)
                        
                        Button("Save") {
                            showDismissAlert = true
                            viewModel.updateSample(sampleNumber: sampleNumber + 1, criteriaRatings: criteriaRatings)
                            
                        }.padding().alert(isPresented: $showDismissAlert) {
                            Alert(title: Text("Success!"), message: Text("Your sample has been updated."), dismissButton: .default(Text("OK")) {
                                dismiss()
                            })
                            
                        }
                    }
                    
                }.foregroundColor(.blue)
                    .background(.green)
            }.onAppear {
                viewModel.loadIssue(issueName: issueName, sampleNumber: sampleNumber)
                criteriaRatings = viewModel.criteriaArray
                self.issueLoaded.toggle()
            }
            .onChange(of: viewModel.criteriaArray) { newValue in
                
            }
        
        
    }
}

//struct SampleView_Previews: PreviewProvider {
//    static var previews: some View {
//        SampleView()
//    }
//}
