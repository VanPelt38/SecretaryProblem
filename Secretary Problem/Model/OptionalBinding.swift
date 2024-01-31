//
//  OptionalBinding.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 24/01/2024.
//

import Foundation
import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        self.init(source)!
    }
}
