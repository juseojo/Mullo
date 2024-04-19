//
//  Main_ViewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

class Main_ViewController: UIViewController {

	let main_view = Main_View()

	override func viewDidLoad() {
		super.viewDidLoad()

		main_view.post_collectionView.dataSource = self
		main_view.post_collectionView.delegate = self

		view.backgroundColor = UIColor(named: "NATURAL")

		self.view.addSubview(main_view)
		main_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}
	}
}

extension Main_ViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//temporary setting
		return 7
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Post_collection_view_cell.identifier, for: indexPath) as? Post_collection_view_cell else {
			return UICollectionViewCell()
		}

		//Have to cell setting

		return cell
	}
}
