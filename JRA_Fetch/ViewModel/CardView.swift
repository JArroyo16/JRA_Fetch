import SwiftUI

struct CardView: View {
    let ingredient: String
    let measure: String
    
    var body: some View {
        VStack {
            Text(ingredient)
                .font(.headline)
                .padding(.bottom, 4)
            Text(measure)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
