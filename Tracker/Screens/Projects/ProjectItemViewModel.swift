import Combine
import Foundation

final class ProjectItemViewModel: ObservableObject, Identifiable, Equatable {
	private(set) var model: ProjectModel
	
	@Published var title: String = ""
	@Published var icon: String?
	@Published var color: ProjectColor = .none
	@Published var selected: Bool = false
	
	static func == (lhs: borrowing ProjectItemViewModel, rhs: borrowing ProjectItemViewModel) -> Bool {
		return lhs.model == rhs.model
	}
	
	init() {
		self.model = ProjectModel()
	}
	
	init(model: ProjectModel) {
		self.model = model
		self.title = model.title
		self.icon = model.icon
		self.color = model.color
	}
}
