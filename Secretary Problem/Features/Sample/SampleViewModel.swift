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
        criteria = []
        criteriaCount = 0
        
        do {
            let result = try context.fetch(request)
            if let fetchedIssue = result.first {
                issue = fetchedIssue
 
                if let theSamples = fetchedIssue.sampleRelationship as? Set<Sample> {
                    let sortedSamples = theSamples.sorted { $0.number < $1.number }
                    for sample in sortedSamples {
                        if sample.number == sampleNumber + 1 {
                            currentSample = sample
                            sampleName = currentSample!.name ?? "Hello"
                            overallScore = Int(currentSample?.overallScore ?? 0)
                            
                            if let criteriaSet = sample.criterionRelationship as? Set<Criterion> {
                                let sortedCriteria = criteriaSet.sorted { $0.name! < $1.name! }
                                for criterion in sortedCriteria {
                                    let crit = Criterion(context: PersistenceController.shared.container.viewContext)
                                    crit.name = criterion.name
                                    crit.weight = criterion.weight
                                    crit.score = criterion.score
                                    criteria.append(crit)
                                    criteriaCount += 1
                                    criteriaArray.append(Int(criterion.score))
                                }
                                criteriaArray.removeFirst()
                            }
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
                
                if let samples = iss.sampleRelationship as? Set<Sample> {
                   
                    for sam in samples {
                       
                        if sam.number == sampleNumber {
                            if iss.isOverallScore {
                                sam.overallScore = Int16(overallScore)
                            } else {
                                sam.overallScore = Int16(calculateOverallScore(criteriaRatings: criteriaRatings))
                            }
                            sam.name = sampleName
                            if let criteria = sam.criterionRelationship as? Set<Criterion> {
                                let sortedCriteria = criteria.sorted { $0.name! < $1.name! }
                                for (index, crit) in sortedCriteria.enumerated() {
                                    crit.score = Int16(criteriaRatings[index])
                                }
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
    }
    
    func calculateOverallScore(criteriaRatings: [Int]) -> Int {
        
        var totalWeightedScore = 0
        var weightSum = 0
        var finalScore = 0
        
        for (index, rating) in criteriaRatings.enumerated() {
            print("rating: \(rating)")
            let weightRate = rating * Int(criteria[index].weight)
            totalWeightedScore += weightRate
            weightSum += Int(criteria[index].weight)
        }

        let scaledWeight = Float(weightSum) / Float(criteriaRatings.count)
        let floatScore = Float(totalWeightedScore) / scaledWeight
        finalScore = Int(floatScore.rounded())
        return finalScore
    }
}
