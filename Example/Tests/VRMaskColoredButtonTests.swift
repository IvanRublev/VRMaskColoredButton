// https://github.com/Quick/Quick

import Quick
import Nimble
import VRMaskColoredButton

/**
 Matcher for UIImage content.
 
 - parameter expectedValue: An UIImage object that's content data to compare against the receiver's data.
 
 - returns: True if images content data are equal.
 */
public func equalContent<T: UIImage>(expectedValue: T?) -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal content to <\(expectedValue)>"
        let limage: UIImage = (try actualExpression.evaluate())!!
        let rimage: UIImage = expectedValue!
        let ldata = UIImagePNGRepresentation(limage)
        let rdata = UIImagePNGRepresentation(rimage)
        return ldata == rdata
    }
}

/// Tests
class VRMaskColoredButtonTest: QuickSpec {
    override func spec() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        func image(name: String) -> UIImage {
            return UIImage(named: name, inBundle: testBundle, compatibleWithTraitCollection: nil)!
        }
        
        describe("Image merge") {
            let image0 = image("merge0")
            let image1 = image("merge1")
            let image2 = image("merge2")
            let assembledImage = image("mergeAssembled")
            let assembledOnImage = image("mergeAssembledTop")
            
            it("can put images under receiver") {
                let merged = image0.imageByMergingWith([image1, image2])
                expect(merged).to(equalContent(assembledImage))
            }
            
            it("can put images on receiver") {
                let merged = image0.imageByMergingWith([image1, image2], onTop: true)
                expect(merged).to(equalContent(assembledOnImage))
            }
        }
        
        describe("Making image by applying colors to mask") {
            let mask = image("PaintMask")
            let backgroundImage = image("PaintBackground")
            let painted = image("PaintedImage")
            let paintedBg = image("PaintedImageBg")
            let fgColor = UIColor(red: 51/255, green: 51/255, blue: 102/255, alpha: 1.0)
            let bgColor = UIColor(red: 102/255, green: 153/255, blue: 102/255, alpha: 1.0)
            
            it("can paint foreground and background") {
                let image = mask.imageByApplyingColor(fgColor, backgroundColor: bgColor)
                expect(image).to(equalContent(painted))
            }
            
            it("can paint foreground then merge with background image") {
                let image = mask.imageByApplyingColor(fgColor, mergeWithBackgroundImage: backgroundImage)
                expect(image).to(equalContent(paintedBg))
            }
        }
        
    }
}
