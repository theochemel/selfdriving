import Foundation
import UIKit

public class PipelineElement {

    var name: String!
    public var description: String!
    var shortDescription: String!
    var shouldDisplayLoadingAnimation: Bool!
    public var algorithmParameters: [AlgorithmParameter] = []
    public var execute: ([AlgorithmParameter], Any, Frame) -> (UIView, Any)
    
    var resultView: UIView!
    var result: Any!
    
    public init(name: String, description: String, shortDescription: String, shouldDisplayLoadingAnimation: Bool, algorithmParameters: [AlgorithmParameter], execute: @escaping ([AlgorithmParameter], Any, Frame) -> (UIView, Any)) {
        self.name = name
        self.description = description
        self.shortDescription = shortDescription
        self.shouldDisplayLoadingAnimation = shouldDisplayLoadingAnimation
        self.algorithmParameters = algorithmParameters
        self.execute = execute
    }
}
