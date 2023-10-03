import Foundation

struct Meals<T: Codable> : Codable{
    var meals : [T]
}
