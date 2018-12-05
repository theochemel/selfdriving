import Foundation
import AVFoundation
import UIKit

// MARK: Video class

public class Video {
    public let filePath: URL!
    public let videoAsset: AVAsset!
    public let imageGenerator: AVAssetImageGenerator!
    
    public let frameRate: Float!
    public let frameCount: Int!
    
    public init(videoAt path: URL) {
        filePath = path
        videoAsset = AVAsset(url: filePath)
        imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        
        guard let assetTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { fatalError("Couldn't create a video asset track") }
        frameRate = assetTrack.nominalFrameRate
        
        frameCount = Int((videoAsset.duration.seconds * Double(frameRate)))
    }
    
    public func getFrame(_ index: Int) -> Frame {
        var frame: Frame!
        
        var image: CGImage!
        do {
            image = try imageGenerator.copyCGImage(at: CMTime(seconds: Double(index) / 25, preferredTimescale: CMTimeScale(25)), actualTime: nil)
        } catch {
            fatalError("Couldn't generate image")
        }
        
        return Frame(fromImage: image)
    }
}
