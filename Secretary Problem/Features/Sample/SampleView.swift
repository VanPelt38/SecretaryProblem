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
    @State private var criteriaRatings: [Int] = [1]
    @StateObject private var viewModel = SampleViewModel()
    @State private var issueLoaded = false
    @State private var showDismissAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let _ = print("this is overall score: \(viewModel.issue.isOverallScore)")
        let _ = print("this is fetched issue in view: \(viewModel.issue)")
        let _ = print("this is criteria count in view: \(viewModel.criteriaCount)")
        ScrollView {
            VStack {
                HStack {
                    Text("Sample Name:").padding()
                    TextField("choose name", text: $sampleName).foregroundColor(.black).padding().textFieldStyle(RoundedBorderTextFieldStyle() )
                }
                
                    if !viewModel.issue.isOverallScore {
                        
                        ForEach(0..<(viewModel.criteriaCount), id: \.self) { count in
                            
                                                        let _ = print("count: \(viewModel.criteria.count)")
                            Text("\(count + 1). \(viewModel.criteria[count].name! as String):").padding()
                            
                            let _ = print("this is criteria ratings: \(criteriaRatings.count)")
                            
                            Picker("", selection: $criteriaRatings[count + 1]) {
                                ForEach(0...10, id: \.self) {
                                    Text("\($0)")
                                }
                            }.pickerStyle(WheelPickerStyle())
                            //                            .onChange(of: selectedWeight) { newValue in
                            //
                            //                        }
                            
                            
                        }
                    }
                Button("Save") {
                    showDismissAlert = true
                    
                    viewModel.updateSample()
                    
                }.padding().alert(isPresented: $showDismissAlert) {
                    Alert(title: Text("Success!"), message: Text("Your sample has been updated."), dismissButton: .default(Text("OK")) {
                        dismiss()
                    })
                    
                }
                
                
            }.foregroundColor(.blue)
                .background(.green)
        }.onAppear {
            viewModel.loadIssue(issueName: issueName)
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
