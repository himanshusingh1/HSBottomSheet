//
//  ViewController.swift
//  HSBottomSheet
//
//  Created by Himanshu on 08/11/2021.
//  Copyright (c) 2021 Himanshu. All rights reserved.
//

import UIKit
import HSBottomSheet

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomSheetButton: UIButton!
    @IBOutlet weak var leftSideMenuButton: UIButton!
    @IBOutlet weak var rightSideMenuButton: UIButton!
    @IBOutlet weak var centerSideMenuButton: UIButton!
    @IBOutlet weak var topSideMenuButton: UIButton!
    @IBOutlet weak var bottomSideMenuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Style buttons
        [bottomSheetButton, leftSideMenuButton, rightSideMenuButton, 
         centerSideMenuButton, topSideMenuButton, bottomSideMenuButton].forEach { button in
            button?.layer.cornerRadius = 8
            button?.backgroundColor = .systemBlue
            button?.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func showBottomSheetTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        HSBottomSheet.show(
            edges: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0),
            masterViewController: vc!,
            cornerRadius: 20,
            canDissmiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDissMiss: {
                print("Bottom sheet dismissed")
            }
        )
    }
    
    @IBAction func showLeftSideMenuTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        let config = SideMenuConfiguration(
            position: .left,
            alignment: .fullHeight,
            widthPercentage: 0.8,
            cornerRadius: 20,
            canDismiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDismiss: {
                print("Left side menu dismissed")
            }
        )
        HSBottomSheet.showSideMenu(viewController: vc!, configuration: config)
    }
    
    @IBAction func showRightSideMenuTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        let config = SideMenuConfiguration(
            position: .right,
            alignment: .fullHeight,
            widthPercentage: 0.7,
            cornerRadius: 20,
            canDismiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDismiss: {
                print("Right side menu dismissed")
            }
        )
        HSBottomSheet.showSideMenu(viewController: vc!, configuration: config)
    }
    
    @IBAction func showCenterSideMenuTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        let config = SideMenuConfiguration(
            position: .left,
            alignment: .center,
            widthPercentage: 0.6,
            cornerRadius: 20,
            canDismiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDismiss: {
                print("Center side menu dismissed")
            }
        )
        HSBottomSheet.showSideMenu(viewController: vc!, configuration: config)
    }
    
    @IBAction func showTopSideMenuTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        let config = SideMenuConfiguration(
            position: .left,
            alignment: .top,
            widthPercentage: 0.5,
            cornerRadius: 20,
            canDismiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDismiss: {
                print("Top side menu dismissed")
            }
        )
        HSBottomSheet.showSideMenu(viewController: vc!, configuration: config)
    }
    
    @IBAction func showBottomSideMenuTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        let config = SideMenuConfiguration(
            position: .right,
            alignment: .bottom,
            widthPercentage: 0.4,
            cornerRadius: 20,
            canDismiss: true,
            dismissButtonConfig: { button in
                button.setTitle("✕", for: .normal)
                button.backgroundColor = .systemRed
            },
            didDismiss: {
                print("Bottom side menu dismissed")
            }
        )
        HSBottomSheet.showSideMenu(viewController: vc!, configuration: config)
    }
}

