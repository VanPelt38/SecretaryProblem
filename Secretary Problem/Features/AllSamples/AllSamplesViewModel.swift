//
//  AllSamplesViewModel.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 05/12/2023.
//

import Foundation
import SwiftUI

class AllSamplesViewModel: ObservableObject {
    
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
