import Combine
import Foundation

final class TasksViewModel: ObservableObject {
	private let modelsManager = ModelsManager.shared
	private let timersManager = TimersManager.shared
	
	@Published public var tasks: [TaskItemViewModel] = []
	
	init() {
		loadData()
	}
	
	func addNewTask(task: TaskViewModel) {
		saveAndAdd(model: task.model)
	}
	
	func refresh(task: TaskViewModel) {
		if let index = tasks.firstIndex(where: { t in
			t.model.id == task.model.id
		}) {
			tasks[index] = TaskItemViewModel(model: task.model)
			timersManager.update(task: task.model)
		}
	}
	
	func startNewTask() {
		let model = TaskModel()
		model.title = "Без названия \((tasks.count + 1))"
		let task = saveAndAdd(model: model)
		task.play()
	}
	
	@discardableResult
	func saveAndAdd(model: TaskModel) -> TaskItemViewModel {
		modelsManager.insert(model)
		let task = TaskItemViewModel(model: model)
		tasks.append(task)
		return task
	}
	
	func loadData() {
		if let results: [TaskModel] = modelsManager.fetch() {
			tasks.append(contentsOf: results.map({ model in
				TaskItemViewModel(model: model)
			}))
		}
	}
}

class TaskSummaryViewModel: ObservableObject {
	@Published public var tasks: [TaskItemViewModel] = []
}
