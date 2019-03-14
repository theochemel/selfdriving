import Foundation

public class PipelineElement {

    var name: String!
    var description: String!
    var shortDescription: String!
    
    public init(name: String, description: String, shortDescription: String) {
        self.name = name
        self.description = description
        self.shortDescription = shortDescription
    }
}
