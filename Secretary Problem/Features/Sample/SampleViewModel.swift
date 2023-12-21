//
//  SampleViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 12/12/2023.
//

import Foundation
import CoreData

class SampleViewModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    @Published var issue = Issue(context: PersistenceController.shared.container.viewContext)
    @Published var criteria: [Criterion] = []
    @Published var criteriaCount = 0
    @Published var criteriaArray: [Int] = [1]
    
    func loadIssue(issueName: String) {
        
        let request: NSFetchRequest<Issue> = Issue.fetchRequest()
        
        request.predicate = NSPredicate(format: "name == %@", issueName)
        request.relationshipKeyPathsForPrefetching = ["relationship"]
        
        
        do {
            let result = try context.fetch(request)
            if let fetchedIssue = result.first {
                issue = fetchedIssue
                print("this is the fetched issue: \(issue)")
                if let criteriaSet = fetchedIssue.relationship as? Set<Criterion> {
                    for criterion in criteriaSet {
                        let crit = Criterion(context: PersistenceController.shared.container.viewContext)
                        crit.name = criterion.name
                        crit.weight = criterion.weight
                        criteria.append(crit)
                        criteriaCount += 1
                        criteriaArray.append(1)
                    }
                    print("this is criteria count: \(criteriaCount)")
                }
            }
        } catch {
            print("error loading issues from CD: \(error)")
        }
    }
    
    func updateSample(sampleNumber: Int, sampleName: String, criteriaRatings: [Int]) {
        
        calculateOverallScore(overallScore: issue.)
    }
    
    func calculateOverallScore(overallScore: Int, criteriaRatings: [Int]) -> Int {
        
    }
}
