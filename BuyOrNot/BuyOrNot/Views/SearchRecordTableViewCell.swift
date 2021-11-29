//
//  searchRecordTableViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/30.
//

import UIKit
import SnapKit

protocol SearchRecordTableViewCellDelegate: AnyObject {
    func removeCell(indexPath: IndexPath)
}

final class SearchRecordTableViewCell: UITableViewCell {
    static let reuseIdentifier = "searchRecordTableViewCell"

    weak var searchRecordTableViewCellDelegate: SearchRecordTableViewCellDelegate?
    var indexPath: IndexPath?
    private(set) var titleLabel = UILabel()
    private let removeButtonImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setRemoveButtonImageView()
        setTitleLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setTitleLabelText(title: String) {
        titleLabel.text = title
    }

    private func setRemoveButtonImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped(_:)))
        removeButtonImageView.isUserInteractionEnabled = true
        removeButtonImageView.addGestureRecognizer(gesture)
        removeButtonImageView.image = UIImage(named: "xmark")?
            .withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        removeButtonImageView.tintColor = .darkGray
        contentView.addSubview(removeButtonImageView)
        removeButtonImageView.snp.makeConstraints { imageView in
            imageView.top.trailing.bottom.equalTo(contentView)
            imageView.width.equalTo(removeButtonImageView.snp.height)
        }
    }

    private func setTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.leading.equalTo(contentView).inset(20)
            label.top.bottom.equalTo(contentView)
            label.trailing.equalTo(removeButtonImageView.snp.leading)
        }
    }

    @objc private func removeButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let indexPath = indexPath else { return }
        searchRecordTableViewCellDelegate?.removeCell(indexPath: indexPath)
    }
}
