import Foundation

public func drawLines(onFrame frame: Frame, lines: [[Int]]) -> Frame {
    for line in lines {
        let t = line[0]
        let p = line[1]
        
        for x in 0 ..< frame.image.width {
            let tDouble = Double(exactly: t)! * Double.pi / 180
            let pDouble = Double(exactly: p)!
            let xDouble = Double(exactly: x)!
            let yValue = (pDouble - xDouble * sin(tDouble)) / cos(tDouble)
            
            guard yValue < Double(frame.image.height) && yValue > 0 else { continue }
            
            let yInt = Int(yValue)
            
            setPixel(value: 0, data: frame.pointer, x: x, y: yInt, imageWidth: frame.image.width)
        }
    }
    
    return Frame(fromGrayscaleData: frame.data, bytesPerRow: frame.image.width)
}
