//
//  Comments_model.swift
//  Mullo
//
//  Created by seongjun cho on 7/14/24.
//

import Foundation

struct Comments_cell_data: Codable{
	var post_num: Int
	var name: String
	var time: String
	var comment: String
	var up_count: String

	init(post_num: Int, name: String, time: String, comment: String, up_count: String) {
		self.post_num = post_num
		self.name = name
		self.time = time
		self.comment = comment
		self.up_count = up_count
	}
}
