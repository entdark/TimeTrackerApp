import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
	private let modelsManager = ModelsManager.shared
	
	func removeAllTasks() {
		modelsManager.delete(type: TaskModel.self)
	}
	
	func removeAllProjects() {
		modelsManager.delete(type: ProjectModel.self)
	}
}
