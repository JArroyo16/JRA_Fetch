import Foundation

class MealsViewModel {
    static func GetMeals(response: @escaping (Meals<InfoMeals>?, Error?) -> Void) {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Meals<InfoMeals>.self, from: dataSource)
                    response(result, nil)
                } else if let errorSource = error {
                    response(nil, errorSource)
                }
            } catch {
                response(nil, error)
            }
        }.resume()
    }
    
    static func GetDetails(idMeal: Int, response: @escaping (Meals<InfoMeals>?, Error?) -> Void) {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Meals<InfoMeals>.self, from: dataSource)
                    response(result, nil)
                } else if let errorSource = error {
                    response(nil, errorSource)
                }
            } catch {
                response(nil, error)
            }
        }.resume()
    }
}
