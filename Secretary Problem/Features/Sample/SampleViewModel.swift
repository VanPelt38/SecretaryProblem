//
//  SampleViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 12/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class SampleViewModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    @Published var issue: Issue?
    @Published var criteria: [Criterion] = []
    @Published var criteriaCount = 0
    @Published var criteriaArray: [Int] = [1]
    @Published var currentSample: Sample?
    @Published var sampleName = ""
    @Published var overallScore = 0
    
    func loadIssue(issueName: String, sampleNumber: Int) {
        
        let request: NSFetchRequest<Issue> = Issue.fetchRequest()
        
        request.predicate = NSPredicate(format: "name == %@", issueName)
        request.relationshipKeyPathsForPrefetching = ["relationship"]
        criteriaArray = [1]
        
        do {
            let result = try context.fetch(request)
            if let fetchedIssue = result.first {
                issue = fetchedIssue
 
                if let criteriaSet = fetchedIssue.relationship as? Set<Criterion> {
                    for criterion in criteriaSet {
                        
                        let crit = Criterion(context: PersistenceController.shared.container.viewContext)
                        crit.name = criterion.name
                        crit.weight = criterion.weight
                        criteria.append(crit)
                        criteriaCount += 1
                        criteriaArray.append(1)
                    }
                    criteriaArray.removeLast()
                }
                if let theSamples = fetchedIssue.sampleRelationship as? Set<Sample> {
                    let sortedSamples = theSamples.sorted { $0.number < $1.number }
                    for sample in sortedSamples {
                        if sample.number == sampleNumber + 1 {
                            currentSample = sample
                            sampleName = currentSample!.name ?? "Hello"
                            overallScore = Int(currentSample?.overallScore ?? 0)
                        }
                    }
                }
            }
        } catch {
            print("error loading issues from CD: \(error)")
        }
    }
    
    func updateSample(sampleNumber: Int, criteriaRatings: [Int]) {
        
        if let iss = issue {
            if iss.isOverallScore {
                
                if let samples = iss.sampleRelationship as? Set<Sample> {
                   
                    for sam in samples {
                       
                        if sam.number == sampleNumber {
                          
                            sam.overallScore = Int16(overallScore)
                            sam.name = sampleName
                        }
                  
                    }
                }
                
            }
            
            do {
                try context.save()
            } catch {
                print("error saving CD: \(error)")
            }
        }
        
        print(calculateOverallScore(criteriaRatings: criteriaRatings))
    }
    
    func calculateOverallScore(criteriaRatings: [Int]) -> Int {
        
        var totalWeightedScore = 0
        var weightSum = 0
        var finalScore = 0
        
        for (index, rating) in criteriaRatings.enumerated() {
            
            var weightRate = rating * Int(criteria[index].weight)
            totalWeightedScore += weightRate
            weightSum += Int(criteria[index].weight)
        }

        let scaledWeight = Float(weightSum) / Float(criteriaRatings.count)
        var floatScore = Float(totalWeightedScore) / scaledWeight
        finalScore = Int(floatScore.rounded())
        return finalScore
    }
}
