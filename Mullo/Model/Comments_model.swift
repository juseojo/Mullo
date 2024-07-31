//
//  Comments_model.swift
//  Mullo
//
//  Created by seongjun cho on 7/14/24.
//

import Foundation
import RealmSwift

struct Comments_cell_data: Codable{
	var post_num: Int
	var name: String
	var time: String
	var comment: String
	var up_count: Int
	var comment_num: Int

	init(post_num: Int, name: String, time: String, comment: String, up_count: Int, comment_num: Int) {
		self.post_num = post_num
		self.name = name
		self.time = time
		self.comment = comment
		self.up_count = up_count
		self.comment_num = comment_num
	}
}

class Choose_upButton: Object {
	@Persisted var comment_num: Int

	convenience init(comment_num: Int) {
		self.init()
		self.comment_num = comment_num
	}
}

class Comment_DB: Object {
	@Persisted var choose_upButtons: List<Choose_upButton>
}
