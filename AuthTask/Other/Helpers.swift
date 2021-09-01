//
//  Helpers.swift
//  AuthTask
//
//  Created by FAB LAB on 01/09/2021.
//

import UIKit

extension UIViewController {
        
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertError(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
//    func openVC(storyBoard:StoryBoards, identifier:String){
//        let vc = storyBoard.viewController(identifier: identifier) as! UINavigationController
//        revealViewController().pushFrontViewController(vc, animated: true)
//    }
    
    func openShareDilog(text:String) {
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop]

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
//
//    func setupNavBarTitleAndButtons(){
//        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
//        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
//
//    }
////
//    @objc func menuBtnPressed(){
//       revealViewController().rightRevealToggle(animated: true)
//    }
    
    @objc func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
}



extension UIView {
    func overlaps(other view: UIView, in viewController: UIViewController) -> Bool {
        let frame = self.convert(self.bounds, to: viewController.view)
        let otherFrame = view.convert(view.bounds, to: viewController.view)
        return frame.intersects(otherFrame)
    }
    
    func checkViewIsInterSecting(viewsToCheck: [UIView]) -> Bool{
        for viewS in viewsToCheck{ //Running the loop through the subviews array
            if (!(self.isEqual(viewS))){ //Checking the view is equal to view to check or not
                if(self.frame.intersects(viewS.frame)){ //Checking the view is intersecting with other or not
                    return true //If intersected then return true
                }
            }
        }
        return false //If not intersected then return false
    }
    
    func addDashedLine(color: UIColor = .lightGray) {
            layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        self.backgroundColor = .clear
            let cgColor = color.cgColor

            let shapeLayer: CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

            shapeLayer.name = "DashedTopLine"
            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = cgColor
            shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [4, 4]

        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))

            shapeLayer.path = path

            self.layer.addSublayer(shapeLayer)
        }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    enum ViewSide {
            case Left, Right, Top, Bottom
        }

        func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

            let border = CALayer()
            border.backgroundColor = color

            switch side {
            case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
            case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
            case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
            case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
            }

            layer.addSublayer(border)
        }
}

extension UILabel {
    
    
    
    func markAsPrice(normalText:String = "ريال", numberedText:String, colorName:String = "red_background") {

    let text = NSMutableAttributedString(string: " \(normalText) ")
        text.addAttribute(NSAttributedString.Key.font,
                      value: UIFont.init(name: "Tajawal-Regular", size: 12),
                      range: NSRange(location: 0, length: text.length))

    let interactableText = NSMutableAttributedString(string: numberedText)
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.init(name: "Tajawal-Bold", size: 18),
                                      range: NSRange(location: 0, length: interactableText.length))
        interactableText.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.init(named: colorName) ?? UIColor.white,
                                      range: NSRange(location: 0, length: interactableText.length))

    // Adding it all together
        interactableText.append(text)

    // Set the text view to contain the attributed text
        self.attributedText = interactableText
    }
    
    func markAsRemain(normalText:String, numberedText:String, colorName:String = "red_text") {

    let text = NSMutableAttributedString(string: " \(normalText) ")
        text.addAttribute(NSAttributedString.Key.font,
                      value: UIFont.init(name: "Tajawal-Medium", size: 12),
                      range: NSRange(location: 0, length: text.length))

    let interactableText = NSMutableAttributedString(string: numberedText)
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont.init(name: "Tajawal-Medium", size: 12),
                                      range: NSRange(location: 0, length: interactableText.length))
        interactableText.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.init(named: colorName) ?? UIColor.init(hexString: "#FA4248"),
                                      range: NSRange(location: 0, length: interactableText.length))

    // Adding it all together
        interactableText.append(text)

    // Set the text view to contain the attributed text
        self.attributedText = interactableText
    }
}
