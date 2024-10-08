//
//  Image_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit

import SnapKit

final class Image_collectionView_cell: UICollectionViewCell {
	static let identifier = "images"

	var image_view: UIImageView = {
		let image_view = UIImageView()

		image_view.backgroundColor = UIColor.lightGray
		image_view.tintColor = UIColor.black
		image_view.contentMode = .scaleAspectFit
		image_view.clipsToBounds = true
		image_view.layer.cornerRadius = 5

		return image_view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor(named: "NATURAL")
		
		addSubview(image_view)

		image_view.snp.makeConstraints { make in
			make.top.left.equalTo(self)
			make.height.equalTo(screen_height * 0.3 - 20)
			make.width.equalTo(screen_height * 0.2 - 12)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func prepareForReuse() {
		self.image_view.image = nil
	}
}
