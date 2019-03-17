import Foundation
import UIKit

public class PipelineElement {

    var name: String!
    public var description: String!
    var shortDescription: String!
    public var algorithmParameters: [AlgorithmParameter] = []
    public var execute: ([AlgorithmParameter], Any) -> (UIView, Any)
    
    var resultView: UIView!
    var result: Any!
    
    public init(name: String, description: String, shortDescription: String, algorithmParameters: [AlgorithmParameter], execute: @escaping ([AlgorithmParameter], Any) -> (UIView, Any)) {
        self.name = name
        self.description = description
        self.shortDescription = shortDescription
        self.algorithmParameters = algorithmParameters
        self.execute = execute
    }
}
