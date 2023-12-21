//
//  MyIssuesViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 03/12/2023.
//

import Foundation
import CoreData

class MyIssuesViewModel: ObservableObject {
    
    let context = PersistenceController.shared.container.viewContext
    @Published var issues: [Issue] = []
    
    func loadIssues() {
        
        let request: NSFetchRequest<Issue> = Issue.fetchRequest()
        do {
            issues = try context.fetch(request)
        } catch {
            print("error loading issues from CD: \(error)")
        }
    }
}
