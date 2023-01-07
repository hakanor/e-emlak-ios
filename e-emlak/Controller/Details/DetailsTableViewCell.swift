//
//  DetailsTableViewCell.swift
//  e-emlak
//
//  Created by Hakan Or on 5.12.2022.
//

import Foundation
import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = themeColors.grey
        return view
    }()

    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        [leftLabel, rightLabel, dividerView] .forEach(contentView.addSubview(_:))
        leftLabel.anchor(left: contentView.leftAnchor)
        rightLabel.anchor(right: contentView.rightAnchor)
        dividerView.anchor(top : leftLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 5, height: 1)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dividerView.backgroundColor = themeColors.lightGrey
    }
    
    // MARK: - Configuration
    
    func config(leftSide:String, rightSide:String){
        leftLabel.text = leftSide
        rightLabel.text = rightSide
    }
    
}
