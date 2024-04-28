//
//  util.swift
//  Mullo
//
//  Created by seongjun cho on 4/16/24.
//

import UIKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05
let top_inset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0

extension String {
	func substr(seperater: Character) -> [String] {
		var result = [String]()
		var text = ""
		var count = 0

		for char in self
		{
			if char == seperater
			{
				result.append(text)
				text = ""
				count += 1
				continue
			}

			text.append(char)
		}

		result.append(text)
		return result
	}
}
