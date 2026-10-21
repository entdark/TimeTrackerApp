import Combine
import Foundation

final class ProjectViewModel: ObservableObject, Hashable {
	private(set) var model: ProjectModel
	
	static func == (lhs: borrowing ProjectViewModel, rhs: borrowing ProjectViewModel) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	@Published var title: String = ""
	@Published var icon: String?
	@Published var color: ProjectColor = .none
	
	var id: UUID { model.id }
	
	init() {
		self.model = ProjectModel()
	}
	
	init(model: ProjectModel) {
		self.model = model
		self.title = model.title
		self.icon = model.icon
		self.color = model.color
	}
	
	convenience init?(model: ProjectModel?) {
		if let model {
			self.init(model: model)
		} else {
			return nil
		}
	}
	
	func save() -> ProjectViewModel {
		let title = self.title.trimmingCharacters(in: .whitespaces)
		if title.isEmpty {
			model.title = "Проект без названия"
		} else {
			model.title = title
		}
		model.icon = self.icon
		model.color = self.color
		return self
	}
}
