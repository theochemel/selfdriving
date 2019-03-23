import Foundation
import UIKit

let performLineGrouping = { (params: [AlgorithmParameter], previousResult: Any, originalFrame: Frame) -> (UIView, Any) in
    guard let previousLines = previousResult as? [[Int]] else { fatalError("performLineGrouping takes a [[Int]] for previousResult, recieved other") }
    
    guard let leftMinSlope = params.first(where: { $0.name == "Left Min Slope" } ) else { fatalError("performLineGrouping takes a Left Min Slope parameter") }
    guard let leftMaxSlope = params.first(where: { $0.name == "Left Max Slope" } ) else { fatalError("performLineGrouping takes a Left Max Slope parameter")}
    guard let rightMinSlope = params.first(where: { $0.name == "Right Min Slope" } ) else { fatalError("performLineGrouping takes a Right Min Slope parameter") }
    guard let rightMaxSlope = params.first(where: { $0.name == "Right Max Slope" } ) else { fatalError("performLineGrouping takes a Right Max Slope parameter") }
    
    var leftLines: [[Int]] = []
    var rightLines: [[Int]] = []
    
    _ = previousLines.map { line in
        if line[0] > leftMinSlope.value && line[0] < leftMaxSlope.value {
            leftLines.append(line)
        } else if line[0] > rightMinSlope.value && line[0] < rightMaxSlope.value {
            rightLines.append(line)
        }
    }
    
    var detectedLaneLines: [[Int]] = []
    
    if leftLines.count > 0 {
    
        var leftLineTotals = (theta: 0, rho: 0)
        for line in leftLines {
            leftLineTotals.theta += line[0]
            leftLineTotals.rho += line[1]
        }

        let leftLine = [leftLineTotals.theta / leftLines.count, leftLineTotals.rho / leftLines.count]
        
        detectedLaneLines.append(leftLine)
    }
    
    if rightLines.count > 0 {
        
        var rightLineTotals = (theta: 0, rho: 0)
        for line in rightLines {
            rightLineTotals.theta += line[0]
            rightLineTotals.rho += line[1]
        }
        
        let rightLine = [rightLineTotals.theta / rightLines.count, rightLineTotals.rho / rightLines.count]
        
        detectedLaneLines.append(rightLine)
    }
    
    return (LineVisualization(frame: originalFrame, lines: detectedLaneLines, lineWidth: 4.0, lineColor: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor), detectedLaneLines)
}
