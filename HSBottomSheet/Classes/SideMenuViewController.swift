//
// SideMenuViewController.swift
// HSBottomSheet
//
// Created by Himanshu Singh on 05/08/21.
//

import UIKit

public enum SideMenuPosition {
    case left
    case right
}

public enum SideMenuAlignment {
    case top
    case center
    case bottom
    case fullHeight
}

public struct SideMenuConfiguration {
    public let position: SideMenuPosition
    public let alignment: SideMenuAlignment
    public let widthPercentage: CGFloat // 0.0 to 1.0
    public let cornerRadius: CGFloat?
    public let canDismiss: Bool
    public let dismissButtonConfig: HSBottomSheet.dismissButtonConfiguration?
    public let didDismiss: (() -> Void)?
    
    public init(
        position: SideMenuPosition = .left,
        alignment: SideMenuAlignment = .fullHeight,
        widthPercentage: CGFloat = 0.8,
        cornerRadius: CGFloat? = 20,
        canDismiss: Bool = true,
        dismissButtonConfig: HSBottomSheet.dismissButtonConfiguration? = nil,
        didDismiss: (() -> Void)? = nil
    ) {
        self.position = position
        self.alignment = alignment
        self.widthPercentage = max(0.1, min(1.0, widthPercentage))
        self.cornerRadius = cornerRadius
        self.canDismiss = canDismiss
        self.dismissButtonConfig = dismissButtonConfig
        self.didDismiss = didDismiss
    }
}

class SideMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private var contentViewController: UIViewController!
    private var configuration: SideMenuConfiguration!
    private var originalPosition: CGPoint?
    private var currentPositionTouched: CGPoint?
    
    // MARK: - UI Elements
    @IBOutlet weak var visualView: UIVisualEffectView!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    lazy private var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapOnDismissButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    class func `init`(
        contentViewController: UIViewController,
        configuration: SideMenuConfiguration
    ) -> SideMenuViewController {
        let bundle = Bundle.init(identifier: "org.cocoapods.HSBottomSheet")
        let vc = UIStoryboard(name: "SideMenu", bundle: bundle).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        vc.contentViewController = contentViewController
        vc.configuration = configuration
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContentViewController()
        setupDismissButton()
        setupPanGesture()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.01)
    }
    
    private func setupContentViewController() {
        self.contentViewController.willMove(toParent: self)
        addChild(self.contentViewController)
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.didMove(toParent: self)
        addAutoLayout()
    }
    
    private func setupDismissButton() {
        if let config = self.configuration.dismissButtonConfig {
            config(dismissButton)
        } else {
            dismissButton.isHidden = true
        }
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dismissButton)
        dismissButton.layer.cornerRadius = 25
        dismissButton.clipsToBounds = true
        
        var constraints: [NSLayoutConstraint] = [
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ]
        
        // Position dismiss button based on side menu position
        switch configuration.position {
        case .left:
            constraints.append(dismissButton.leadingAnchor.constraint(equalTo: self.contentViewController.view.trailingAnchor, constant: -16))
        case .right:
            constraints.append(dismissButton.trailingAnchor.constraint(equalTo: self.contentViewController.view.leadingAnchor, constant: 16))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupPanGesture() {
        panGesture.delegate = self
    }
    
    // MARK: - Auto Layout
    private func addAutoLayout() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Calculate width based on percentage
        let screenWidth = UIScreen.main.bounds.width
        let menuWidth = screenWidth * configuration.widthPercentage
        
        // Width constraint
        contentViewController.view.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
        
        // Position constraint based on configuration
        switch configuration.position {
        case .left:
            contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        case .right:
            contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        
        // Alignment constraints
        switch configuration.alignment {
        case .top:
            contentViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            contentViewController.view.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .center:
            contentViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            contentViewController.view.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            contentViewController.view.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .bottom:
            contentViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            contentViewController.view.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        case .fullHeight:
            contentViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            contentViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        
        // Corner radius
        if let cornerRadius = configuration.cornerRadius {
            contentViewController.view.clipsToBounds = true
            contentViewController.view.layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Actions
    @objc private func didTapOnDismissButton() {
        configuration.didDismiss?()
        HSBottomSheet.dismiss(vc: self.contentViewController)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        panGestureAction(sender)
    }
    
    // MARK: - Pan Gesture Handling
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            let newX = configuration.position == .left ? 
                max(0, translation.x) : 
                min(0, translation.x)
            
            view.frame.origin = CGPoint(
                x: newX,
                y: view.frame.minY
            )
            
            self.visualView.alpha = max(0.7, CGFloat(0.7 - Double(abs(translation.x) / self.view.frame.width)))
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            let shouldDismiss = (configuration.position == .left && velocity.x <= -1500) ||
                               (configuration.position == .right && velocity.x >= 1500) ||
                               abs(translation.x) > view.frame.width * 0.5
            
            if shouldDismiss && configuration.canDismiss {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    guard let self = self else { return }
                    let dismissX = self.configuration.position == .left ? 
                        -self.view.frame.width : 
                        self.view.frame.width
                    self.view.frame.origin = CGPoint(x: dismissX, y: self.view.frame.origin.y)
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.didTapOnDismissButton()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    guard let self = self else { return }
                    self.visualView.alpha = 0.7
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
} 