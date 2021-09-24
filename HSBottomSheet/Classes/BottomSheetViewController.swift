//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Himanshu Singh on 05/08/21.
//

import UIKit


public extension UIViewController {
    func showBottomSheet(edges: UIEdgeInsets? = nil, masterViewController: UIViewController, cornerRadius: CGFloat? = nil) {
        let bottomSheetVC = BottomSheetViewController.`init`(edges: edges, masterViewController: masterViewController, cornerRadius: cornerRadius) 
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}

class BottomSheetViewController: UIViewController , UIGestureRecognizerDelegate{
    
    class func `init`(edges: UIEdgeInsets? = nil, masterViewController: UIViewController, cornerRadius: CGFloat? = nil) -> BottomSheetViewController {
        let vc = UIStoryboard(name: "BottomSheet", bundle: Bundle.init(identifier: "org.cocoapods.HSBottomSheet")).instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        vc.contentViewController = masterViewController
        vc.cornerRadius = cornerRadius ?? 5
        vc.modalPresentationStyle = .overFullScreen
        vc.edgeInsets = edges ?? UIEdgeInsets(top: 22, left: 16, bottom: 16, right: 16)
        return vc
    }
    
    @IBOutlet weak var visualView: UIVisualEffectView!
    private weak var contentViewController: UIViewController!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    private var cornerRadius: CGFloat!
    private var edgeInsets: UIEdgeInsets!
    private var originalPosition: CGPoint?
    private var currentPositionTouched: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.01)
        self.contentViewController.willMove(toParent: self)
        addChild(self.contentViewController)
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.didMove(toParent: self)
        addAutoLayout()
        
        swizzleDissmiss()
        
        
        
    }
    private func swizzleDissmiss() {
        let instance: UIViewController = self.contentViewController
        let aClass: AnyClass! = object_getClass(instance)
        let originalMethod = class_getInstanceMethod(aClass, #selector(dismiss(animated:completion:)))
        
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(self.dismiss(animated:completion:)))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    private func addAutoLayout() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false

        let leadingLayout = NSLayoutConstraint(item: self.contentViewController.view!, attribute: .leading, relatedBy: .equal, toItem: self.visualView, attribute: .leading, multiplier: 1, constant: self.edgeInsets.left)
        leadingLayout.isActive = true

        let trailingLayout = NSLayoutConstraint(item: self.contentViewController.view!, attribute: .trailing, relatedBy: .equal, toItem: self.visualView, attribute: .trailing, multiplier: 1, constant: -1 * self.edgeInsets.right)
        trailingLayout.isActive = true

        let topLayout = NSLayoutConstraint(item: self.contentViewController.view!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.visualView, attribute: .top, multiplier: 1, constant: self.edgeInsets.top)
        topLayout.priority = UILayoutPriority(rawValue: 1)
        topLayout.isActive = true

        let bottomLayout = NSLayoutConstraint(item: self.contentViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: self.visualView, attribute: .bottom, multiplier: 1, constant: -1 * self.edgeInsets.bottom)
        bottomLayout.isActive = true

        self.contentViewController.view.clipsToBounds = true
        self.contentViewController.view.layer.cornerRadius = cornerRadius
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        panGestureAction(sender)
    }
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: view.frame.minX,
                y: max(0, translation.y)
            )
            self.visualView.alpha = max(0.7, CGFloat( 0.7 - Double(translation.y / self.view.frame.height) ))
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2 , animations: { [weak self] in
                    guard let self = self else { return }
                    self.view.frame.origin = CGPoint(
                        x: self.view.frame.origin.x,
                        y: self.view.frame.size.height
                    )
                }, completion: { [weak self] (isCompleted) in
                    guard let self = self else { return }
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {  [weak self] in
                    guard let self = self else { return }
                    self.visualView.alpha = 0.7
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
    
}
