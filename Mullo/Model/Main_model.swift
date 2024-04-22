//
//  Main_model.swift
//  Mullo
//
//  Created by seongjun cho on 4/20/24.
//

class Post_cell_data {
	var name_text: String = "none"
	var time_text: String = "none"
	var post_text: String = "none"
	var choice_text: String = "none"

	init(name_text: String, time_text: String, post_text: String, choice_text: String) {
		self.name_text = name_text
		self.time_text = time_text
		self.post_text = post_text
		self.choice_text = choice_text
	}
}
