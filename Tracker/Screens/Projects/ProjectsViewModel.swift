import Combine
import Foundation

final class ProjectsViewModel: ObservableObject {
	private static let noProject: ProjectItemViewModel = {
		ProjectItemViewModel(model: ProjectModel.noProject)
	}()
	
	private let modelsManager = ModelsManager.shared
	
	@Published var projects: [ProjectItemViewModel] = [
		noProject
	] {
		didSet {
			setSelectedProject()
		}
	}
	@Published var selectedProject: ProjectItemViewModel {
		didSet {
			setSelectedProject()
		}
	}
	
	private func setSelectedProject() {
		projects.forEach { project in
			project.selected = project == selectedProject
		}
	}
	
	init(selectedProject: ProjectViewModel? = nil) {
		defer {
			loadData()
		}
		guard let selectedProject else {
			self.selectedProject = ProjectsViewModel.noProject
			return
		}
		let project = ProjectItemViewModel(model: selectedProject.model)
		self.selectedProject = project
	}
	
	func loadData() {
		if let results: [ProjectModel] = modelsManager.fetch() {
			projects.append(contentsOf: results.map({ model in
				ProjectItemViewModel(model: model)
			}))
		}
		setSelectedProject()
	}
	
	func addProject(_ project: ProjectViewModel) {
		modelsManager.insert(project.model)
		let project = ProjectItemViewModel(model: project.model)
		projects.append(project)
		selectedProject = project
	}
	
	func saveProject() -> ProjectViewModel? {
		if selectedProject == ProjectsViewModel.noProject {
			return nil
		} else {
			return ProjectViewModel(model: selectedProject.model)
		}
	}
}
