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
        if issues.isEmpty {
            
            let request: NSFetchRequest<Issue> = Issue.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                issues = try context.fetch(request)
            } catch {
                print("error loading issues from CD: \(error)")
            }
        }
    }
}
