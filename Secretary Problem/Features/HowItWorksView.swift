//
//  HowItWorksView.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 24/11/2023.
//

import SwiftUI

struct HowItWorksView: View {
    var body: some View {
        VStack {
            Text("How It Works").padding(EdgeInsets(top: 50, leading: 0, bottom: 20, trailing: 0)).font(Font.system(size: 40))
            Spacer()
            Text("'Secretary Problem' is the name for a common problem people face in everyday lives, whereby they have make the optimal choice from a number of options without knowing if a better one will come along.")
            Spacer()
        }.foregroundColor(.blue)
            .background(.green)
    }
}

struct HowItWorksView_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorksView()
    }
}
