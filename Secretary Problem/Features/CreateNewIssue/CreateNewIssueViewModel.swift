//
//  CreateNewIssueViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 25/11/2023.
//

import Foundation
import CoreData

class CreateNewIssueViewModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    
    func createNewIssue(issueTitle: String?, superset: Int?, isOverallScore: Bool, criteriaCount: Int?, criteriaNames: [String?], criteriaWeights: [Int?]) {
     
        let subset = calculateSubset(superset: superset!)
        
        let newIssue = Issue(context: context)
        newIssue.name = issueTitle!
        newIssue.superset = Int16(superset!)
        newIssue.subset = Int16(subset)
        newIssue.isOverallScore = isOverallScore
        newIssue.criteriaCount = Int16(criteriaCount!)

        
        for sample in 0..<superset! {
            var newSample = Sample(context: context)
            newSample.sampleRelationship = newIssue
            newSample.number = Int16(sample) + 1
            newSample.overallScore = 0
            
            for (index, name) in criteriaNames.enumerated() {
                var newCriterion = Criterion(context: context)
                newCriterion.name = name
                newCriterion.weight = Int16(criteriaWeights[index]!)
                newCriterion.score = 0
                newCriterion.criterionRelationship = newSample
            }
        }
        
        saveData()
    }
    
    func calculateSubset(superset: Int) -> Int {
        
        let e = exp(1.0)
        let subset = Int(Double(superset) * (1/e))
        return subset
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error saving new issue")
        }
    }

}
