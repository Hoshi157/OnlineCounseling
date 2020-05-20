//
//  SidemenuViewController.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class SidemenuViewController: UIViewController {
    
    weak var delegate: SidemenuViewControllerDelegate?
    private let contentView = UIView(frame: .zero)
       private var contentMaxWidth: CGFloat {
           return view.bounds.width * 0.8
       }
    private var contentRatio: CGFloat {
        get{
            return contentView.frame.maxX / contentMaxWidth
        }
        set{
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    var isShow: Bool {
        return parent != nil
    }
    private var beganState: Bool = false
    private var beganLocation: CGPoint = .zero
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backViewTapped(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func backViewTapped(_ sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: self)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        }else {
            contentRatio = 1.0
        }
    }
    
    func hideContentView(animated: Bool, completion: ((Bool) -> Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        }else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    func startPanGestureRecognizing() {
        print("startPan")
        if let parentViewController = self.delegate?.parentViewControllerForSidemenuViewController(self) {
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
            
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
        }
    }
    
    @objc private func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard  let shouldPresent = self.delegate?.shouldPresentSidemenuViewController(self), shouldPresent else {
            return
        }
        let translation = panGestureRecognizer.translation(in: view)
        if translation.x > 0 && contentRatio == 1.0 {
            return
        }
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShow
            beganLocation = location
            if translation.x >= 0 {
                if let parent = self.parent {
                    self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animeted: false, currentViewController: parent)
                }
            }
        case .changed:
            let distance = beganState ? beganLocation.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
        case .ended, .cancelled, .failed:
            if contentRatio >= 1.0, contentRatio <= 0 {
                if location.x > beganLocation.x {
                    showContentView(animated: true)
                }else {
                    self.delegate?.sidemenuViewControllerDidRequestHiding(self, animeted: true)
                }
            }
            beganLocation = .zero
            beganState = false
        default: break
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol SidemenuViewControllerDelegate: class {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController
    func shouldPresentSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animeted: Bool,currentViewController: UIViewController)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animeted: Bool)
    func sidemenuViewcontroller(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath)
}

extension SidemenuViewController: UIGestureRecognizerDelegate {
}
