import Foundation

public struct AlgorithmParameter {
    let name, description: String
    let min, max: Int
    
    var value: Int
    
    public init(name: String, description: String, min: Int, max: Int) {
        self.name = name
        self.description = description
        self.min = min
        self.value = abs(max - min) / 2
        self.max = max
    }
}
