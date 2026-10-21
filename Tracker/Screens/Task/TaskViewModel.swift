import Combine
import Foundation

final class TaskViewModel: ObservableObject {
	private(set) var model: TaskModel
	
	@Published var title: String = ""
	@Published var details: String = ""
	@Published var project: ProjectViewModel?
	@Published var comment: String = ""
	
	init() {
		self.model = TaskModel()
	}
	
	init(model: TaskModel) {
		self.model = model
		self.title = model.title
		self.details = model.details
		self.project = ProjectViewModel(model: model.project)
		self.comment = model.comment
	}
	
	convenience init(model: TaskModel?) {
		if let model {
			self.init(model: model)
		} else {
			self.init()
		}
	}
	
	func save() -> TaskViewModel {
		let title = self.title.trimmingCharacters(in: .whitespaces)
		if title.isEmpty {
			model.title = "Без названия"
		} else {
			model.title = title
		}
		model.details = self.details
		model.project = self.project?.model
		model.comment = self.comment
		return self
	}
}
