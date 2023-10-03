import SwiftUI

struct DetailsMealsView: View {
    var idMeal: String
    @State private var meal: InfoMeals? = nil
    @State private var meals: [InfoMeals] = []
    let columns: [GridItem] = [GridItem(.flexible())]
    
    var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        return style
    }
    
    var body: some View {
        if let meal = meal {
            ScrollView {
                Text(meal.strMeal)
                    .font(.title)
                    .padding()
                    .bold()
                
                AsyncImage(url: URL(string: meal.strMealThumb)) { img in
                    img
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding()
                } placeholder: {
                    ProgressView()
                }
                
                Text("Ingredients:")
                    .font(.headline)
                    .padding()
                    .bold()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(meal.ingredientsAndMeasures.indices, id: \.self) { index in
                            let ingredient = meal.ingredientsAndMeasures[index].ingredient
                            let measure = meal.ingredientsAndMeasures[index].measure
                            VStack {
                                AsyncImage(url: GetURL(name: ingredient!))
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
                                    .padding(.bottom, 8)
                                
                                
                                Text(ingredient ?? "Nil")
                                    .font(.headline)
                                    .padding(.bottom, 4)
                                Text(measure ?? "Nil")
                                    .font(.subheadline)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
                
                Text("Instruccions")
                    .font(.title3)
                    .bold()
                    .padding()
                    .bold()
                Text(meal.strInstructions!)
                    .multilineTextAlignment(.leading)
                    .padding(25)
            }
        } else {
            ProgressView()
                .onAppear {
                    MealsViewModel.GetDetails(idMeal: Int(idMeal)!) { result, error in
                        if let result = result {
                            DispatchQueue.main.async {
                                self.meal = result.meals.first
                            }
                        } else if let error = error {
                            print("Error fetching meal details: \(error)")
                        }
                    }
                }
        }
    }
    
    func GetURL(name: String) -> URL {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "https://www.themealdb.com/images/ingredients/\(sanitizedName)-Small.png")!
    }
    
    
}
