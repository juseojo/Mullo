//
//  Main_model.swift
//  Mullo
//
//  Created by seongjun cho on 4/20/24.
//

import RealmSwift

struct Post_cell_data: Codable{
	var post_num: Int
	var name: String
	var time: String
	var post: String
	var choice: String
	var choice_count: String
	var pictures: String

	init(post_num: Int, name: String, time: String, post: String, choice: String, choice_count: String, pictures: String) {
		self.post_num = post_num
		self.name = name
		self.time = time
		self.post = post
		self.choice = choice
		self.choice_count = choice_count
		self.pictures = pictures
	}
}

class Selected_post: Object {
	@Persisted var post_num: Int
	@Persisted var selected_choice: Int
}

class Mullo_DB: Object {
	@Persisted var selected_posts: List<Selected_post>
}
