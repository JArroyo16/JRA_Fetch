import SwiftUI


struct ContentView: View {
    @State private var meals: [InfoMeals] = []
    @State private var selectedMeal: InfoMeals? = nil
    @State private var isDetailViewPresented = false
    @State private var searchText = ""
    @State private var showAlert = false
    
    var filteredMeals: [InfoMeals] {
        if searchText.isEmpty {
            return meals
        } else {
            return meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search meals", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if filteredMeals.isEmpty && !searchText.isEmpty {
                    Text("No matching meals found.")
                        .foregroundColor(.red)
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("No matching meals found"),
                                message: Text("Try a different search term."),
                                dismissButton: .default(Text("OK")) {
                                    showAlert = false
                                }
                            )
                        }
                } else {
                    List(filteredMeals, id: \.idMeal) { meal in
                        HStack {
                            RemoteImage(url: meal.strMealThumb)
                                .scaledToFill()
                                .cornerRadius(10)
                                .frame(width: 80, height: 80)
                                .padding()
                            
                            Text(meal.strMeal)
                                .font(.headline)
                        }
                        .onTapGesture {
                            selectedMeal = meal
                            isDetailViewPresented.toggle()
                            print(meal.idMeal)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("Desserts")
            .onAppear {
                MealsViewModel.GetMeals { result, error in
                    if let result = result {
                        meals = result.meals
                    } else if let error = error {
                        print("Error: \(error)")
                    }
                }
            }
        }
        .sheet(item: $selectedMeal, content: { meal in
            DetailsMealsView(idMeal: meal.idMeal)
        })
        
    }
    
    func GetURL(name: String) -> URL {
        return URL(string: "www.themealdb.com/images/ingredients/\(name).png")!
    }
}

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

#Preview {
    ContentView()
}
