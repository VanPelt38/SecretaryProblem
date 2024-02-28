//
//  AllSamplesViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 05/12/2023.
//

import Foundation
import SwiftUI
import CoreData

class AllSamplesViewModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    @Published var issues: [Issue] = []
    @Published var sampleNames: [String] = []
    @Published var sampleOverallScores: [Int] = []
    @Published var subsetOverallScores: [Int] = []
    @Published var isBestSubSample: [Bool] = []
    @Published var isStoppingPoint: [Bool] = []
    var stoppingPointReached = false
    var bestSubSampleScore = 0
    
    func loadIssues(_ selectedIssue: Int) {

        issues = []
        sampleNames = []
        sampleOverallScores = []
        isBestSubSample = []
        subsetOverallScores = []
        isStoppingPoint = []
        stoppingPointReached = false
        bestSubSampleScore = 0
            
            let request: NSFetchRequest<Issue> = Issue.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                issues = try context.fetch(request)
            } catch {
                print("error loading issues from CD: \(error)")
            }
            for (index, issue) in issues.enumerated() {
                if index == selectedIssue {
                    if let samples = issue.sampleRelationship as? Set<Sample> {
                        let sortedSamples = samples.sorted { $0.number < $1.number }
                        
                        for sample in sortedSamples {
                            if let name = sample.name {
                                sampleNames.append(name)
                            }
                                sampleOverallScores.append(Int(sample.overallScore))
                        }
                        for number in 0..<Int(issue.subset) {
                            isBestSubSample.append(false)
                            subsetOverallScores.append(sampleOverallScores[number])
                        }
                        
                        if let highestValue = subsetOverallScores.max() {
                            if highestValue > 0 {
                                for (index, item) in subsetOverallScores.enumerated() {
                                    if item == highestValue {
                                        isBestSubSample[index] = true
                                        bestSubSampleScore = item
                                    }
                                }
                            }
                            }
                        let supersetArray = sampleOverallScores[(Int(issue.subset))..<Int(issue.superset)]
                        
                        if let highestSuperSetValue = supersetArray.max() {
                            for v in supersetArray {
                                if v == highestSuperSetValue && v != 0 && v >= bestSubSampleScore && !stoppingPointReached {
                                    isStoppingPoint.append(true)
                                    stoppingPointReached = true
                                } else {
                                    isStoppingPoint.append(false)
                                }
                            }
                        }
                    }
                    }
                    
                }
        }

    
    func getRectangleColour(subset: Int, sample: Int) -> Color {
        if sample <= subset {
            return Color.blue
        } else {
            return Color.red
        }
    }
    
    func getSetName(subset: Int, sample: Int) -> String {
        if sample <= subset {
            return "Subset"
        } else {
            return "Superset"
        }
    }
}
