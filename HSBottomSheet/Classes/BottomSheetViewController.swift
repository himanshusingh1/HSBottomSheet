//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Himanshu Singh on 05/08/21.
//

import UIKit

private var overlayWindow: [UIWindow] = []
class HSNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        HSBottomSheet.dismiss(vc: self)
    }
}
public struct HSBottomSheet {
    public typealias dismissButtonConfiguration = ((UIButton) -> Void)
    public static func dismissAll() {
        overlayWindow.forEach { window in
            window.resignKey()
            window.removeFromSuperview()
        }
        overlayWindow.removeAll()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    public static func dismiss(vc: UIViewController) {
        
        func removeWindow(window: UIWindow) {
            UIView.animate(withDuration: 0.3) {
                window.frame = window.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.maxY)
            } completion: { _ in
                window.resignKey()
                window.removeFromSuperview()
                overlayWindow.removeAll { savedWindow in
                    savedWindow === window
                }
                overlayWindow.last?.makeKeyAndVisible()
            }
        }
        
        if let window = overlayWindow.first(where: { savedwindow in
            return (savedwindow.rootViewController as? BottomSheetViewController)?.contentViewController === vc
        }) {
            removeWindow(window: window)
        } else if let window = overlayWindow.first(where: { window in
            window.rootViewController === vc
        }) {
            removeWindow(window: window)
        } else if let window = overlayWindow.first(where: { window in
            if let rootVC = window.rootViewController as? HSNavigationController {
                let contains = rootVC.viewControllers.contains { viewcon in
                    viewcon === vc
                }
                return contains
            }
            return false
        }){
           removeWindow(window: window)
        }
    }
    
    public static func push(viewController: UIViewController) {
        let nav = HSNavigationController(rootViewController: viewController)
        let newWindow: UIWindow!
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                newWindow = UIWindow(windowScene: currentWindowScene)
            } else {
                newWindow = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            newWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        newWindow.windowLevel = UIWindow.Level.alert
        newWindow.backgroundColor = .clear
        newWindow.rootViewController = nav
        newWindow.makeKeyAndVisible()
        overlayWindow.append(newWindow)
        newWindow.frame = newWindow.frame.offsetBy(dx: UIScreen.main.bounds.maxX, dy: 0)
        UIView.animate(withDuration: 0.3) {
            newWindow.frame = UIScreen.main.bounds
        }
        
    }
    
    public static func show(edges: UIEdgeInsets? = nil, masterViewController: UIViewController, cornerRadius: CGFloat? = nil, canDissmiss: Bool = true,dismissButtonConfig: dismissButtonConfiguration? = nil) {
        
        let bottomSheetVC = BottomSheetViewController.`init`(edges: edges, masterViewController: masterViewController, cornerRadius: cornerRadius, canDissmiss: canDissmiss,dissMissButton: dismissButtonConfig)
        let newWindow: UIWindow!
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
                newWindow = UIWindow(windowScene: currentWindowScene)
            } else {
                newWindow = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            newWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        newWindow.windowLevel = UIWindow.Level.alert
        newWindow.backgroundColor = .clear
        newWindow.rootViewController = bottomSheetVC
        newWindow.makeKeyAndVisible()
        overlayWindow.append(newWindow)
        newWindow.frame = newWindow.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.maxY)
        UIView.animate(withDuration: 0.3) {
            newWindow.frame = UIScreen.main.bounds
        }
    }
}

class BottomSheetViewController: UIViewController , UIGestureRecognizerDelegate{
    
    class func `init`(edges: UIEdgeInsets? = nil, masterViewController: UIViewController, cornerRadius: CGFloat? = nil, canDissmiss: Bool,dissMissButton: HSBottomSheet.dismissButtonConfiguration? ) -> BottomSheetViewController {
        let bundle = Bundle.init(identifier: "org.cocoapods.HSBottomSheet")
        let vc = UIStoryboard(name: "BottomSheet", bundle: bundle).instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        vc.contentViewController = masterViewController
        vc.cornerRadius = cornerRadius ?? 5
        vc.canDissmiss = canDissmiss
        vc.modalPresentationStyle = .overFullScreen
        vc.edgeInsets = edges ?? UIEdgeInsets(top: 22, left: 16, bottom: 16, right: 16)
        vc.dismissButtonConfig = dissMissButton
        return vc
    }
    private var dismissButtonConfig: HSBottomSheet.dismissButtonConfiguration?
    
    @IBOutlet weak var visualView: UIVisualEffectView!
    fileprivate var contentViewController: UIViewController!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    private var canDissmiss: Bool! = true
    private var cornerRadius: CGFloat!
    private var edgeInsets: UIEdgeInsets!
    private var originalPosition: CGPoint?
    private var currentPositionTouched: CGPoint?
    
    lazy private var dissmissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didtapOnDismissButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didtapOnDismissButton() {
        HSBottomSheet.dismiss(vc: self.contentViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        self.contentViewController.willMove(toParent: self)
        addChild(self.contentViewController)
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.didMove(toParent: self)
        addAutoLayout()
        if let config = self.dismissButtonConfig {
            config(dissmissButton)
        } else {
            dissmissButton.isHidden = true
        }
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dissmissButton)
        dissmissButton.layer.cornerRadius = 25
        dissmissButton.clipsToBounds = true
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 50),
            dissmissButton.widthAnchor.constraint(equalToConstant: 50),
            dissmissButton.bottomAnchor.constraint(equalTo: self.contentViewController.view.topAnchor,constant: -16),
            dissmissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                    if isCompleted && self.canDissmiss {
                        HSBottomSheet.dismiss(vc: self.contentViewController)
                    }
                    UIView.animate(withDuration: 0.2, animations: {  [weak self] in
                        guard let self = self else { return }
                        self.visualView.alpha = 0.7
                        self.view.center = self.originalPosition!
                    })
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
