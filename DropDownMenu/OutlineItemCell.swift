//
//  OutlineItemCell.swift
//  DropDownMenu
//
//  Created by Алексей Пархоменко on 18.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class OutlineItemCell: UICollectionViewCell {

    static let reuseIdentifier = "OutlineItemCell"
    
    let label = UILabel()
    let containerView = UIView()
    let imageView = UIImageView()
    
    var indentLevel: Int = 0 {
        didSet {
//            indentContraint.constant = CGFloat(20 * indentLevel)
        }
    }
    var isExpanded = false {
        didSet {
            configureChevron()
        }
    }
    var isGroup = false {
        didSet {
            configureChevron()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            configureChevron()
        }
    }
    override var isSelected: Bool {
        didSet {
            configureChevron()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    fileprivate var indentContraint: NSLayoutConstraint! = nil
    fileprivate let inset = CGFloat(10)

}

extension OutlineItemCell {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        containerView.addSubview(label)

        indentContraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset)
        NSLayoutConstraint.activate([
            indentContraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor)
            ])
    }
    
    func configureChevron() {
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevron = rtl ? "chevron.left.circle.fill" : "chevron.right.circle.fill"
        let chevronSelected = rtl ? "chevron.left.circle.fill" : "chevron.right.circle.fill"
        let circle = "circle.fill"
        let circleFill = "circle.fill"
        let highlighted = isHighlighted || isSelected

        if isGroup {
            let imageName = highlighted ? chevronSelected : chevron
            let image = UIImage(systemName: imageName)
            imageView.image = image
            let rtlMultiplier = rtl ? CGFloat(-1.0) : CGFloat(1.0)
            let rotationTransform = isExpanded ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: rtlMultiplier * CGFloat.pi / 2)
            imageView.transform = rotationTransform
        } else {
            let imageName = highlighted ? circleFill : circle
            let image = UIImage(systemName: imageName)
            imageView.image = image
            imageView.transform = CGAffineTransform.identity
        }

        imageView.tintColor = highlighted ? .gray : .cornflowerBlue

    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}

