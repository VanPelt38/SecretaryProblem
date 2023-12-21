//
//  CreateNewIssueView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 24/11/2023.
//

import SwiftUI

struct CreateNewIssueView: View {
    
    @State private var text: String = ""
    @State private var text2: String = ""
    @State private var selectedSuperset: Int = 0
    @State private var criteriaCount: Int = 1
    @State private var selectedScoringOption: String = ""
    @State private var selectedWeight: Int = 1
    @State private var criteriaAreHidden = true
    @State private var criteriaTextValues: [String] = ["Default"]
    @State private var weightingSelections: [Int] = [1]
    let scoringOptions = ["Overall Score", "Different Criteria"]
    let scoringWeights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var showDismissAlert = false
    let viewModel = CreateNewIssueViewModel()
    
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        ScrollView {
        VStack {
            Group {
                Text("Create New Issue").padding(EdgeInsets(top: 50, leading: 0, bottom: 20, trailing: 0)).font(Font.system(size: 40))
                Text("First of all - what issue do you want to resolve? (e.g. Choose the best apartment)").padding()
                TextField("Enter text here", text: $text).foregroundColor(.black).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Now, time to specify your superset.(e.g. The maxium number of apartments you're willing to view before making a decision)").padding()
                Picker("Select an option", selection: $selectedSuperset) {
                    ForEach(1...1000, id: \.self) {
                        Text("\($0)")
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            Text("So far so good! Now, how are you going to rank your choices? (e.g. Give each apartment an overall score, or calculate a score based on different criteria)").padding()
            Picker("Select an option", selection: $selectedScoringOption) {
                ForEach(scoringOptions, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedScoringOption) { newValue in
                    if newValue == "Different Criteria" {
                        criteriaAreHidden = false
                    } else {
                        criteriaAreHidden = true
                    }
                }
            if !criteriaAreHidden {
                
                ForEach(0..<criteriaCount, id: \.self) {count in
                    
                    HStack {
                        
                        TextField("Criterion 1 (e.g. proximity to schools)", text: $criteriaTextValues[count] ).foregroundColor(.black).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                        if count == 0 {
                            Button(action: {
                                criteriaCount += 1
                                criteriaTextValues.append("Default")
                                weightingSelections.append(1)
                            }) {
                                Image(systemName: "plus.app.fill")
                            }.padding()
                            Button(action: {
                                if criteriaCount > 1 {
                                    criteriaCount -= 1
                                    criteriaTextValues.removeLast()
                                    weightingSelections.removeLast()
                                }
                            }) {
                                Image(systemName: "minus.square.fill")
                            }.padding()
                        }
                    }
                    
                    Text("Do you want to give extra weight to this criterion? (e.g. Location is more important than rent)").padding()
                    Picker("Select an option", selection: $weightingSelections[count]) {
                        ForEach(scoringWeights, id: \.self) {
                            if $0 == 1 {
                                Text("\($0) (default)")
                            } else {
                                Text("\($0)")
                            }
                        }
                    }.pickerStyle(WheelPickerStyle()).onChange(of: selectedWeight) { newValue in
                        
                    }

                }
            
            }
            Button("Create My Issue") {
                showDismissAlert = true

                viewModel.createNewIssue(issueTitle: text, superset: selectedSuperset, isOverallScore: criteriaAreHidden, criteriaCount: criteriaCount, criteriaNames: criteriaTextValues, criteriaWeights: weightingSelections)
                
            }.padding().alert(isPresented: $showDismissAlert) {
                Alert(title: Text("Success!"), message: Text("Your issue has been created."), dismissButton: .default(Text("OK")) {
                    dismiss()
                })
                
            }
        }.foregroundColor(.blue)
            .background(.green)
    }
    }
}

struct CreateNewIssueView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewIssueView()
    }
}

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}
