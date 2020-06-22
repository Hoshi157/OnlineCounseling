//
//  WelcomeView.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var phoneImage: UIImageView = {
        let imageView = UIImageView()
        let image = self.cropped(to: CGRect(x: 0, y: 0, width: 1200, height: 900), image: #imageLiteral(resourceName: "Apple iPhone XR Blue"))
        imageView.image = image
        return imageView
    }()

    override init(frame: CGRect) {
            super.init(frame: frame)
            loadView()
            phoneView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            loadView()
            phoneView()
        }
        
        func loadView() {
            guard let view = UINib(nibName: "WelcomeView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
                return
            }
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
    }
    
    func phoneView() {
        self.addSubview(phoneImage)
        phoneImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(420)
        }
    }
    
    func cropped(to: CGRect, image: UIImage?) -> UIImage? {
        guard let _image = image else { return nil }
        guard let imageRef = _image.cgImage?.cropping(to: to) else { return nil }
        return UIImage(cgImage: imageRef, scale: _image.scale, orientation: _image.imageOrientation)
    }
}
