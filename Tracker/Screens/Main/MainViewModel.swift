import Combine
import Foundation

final class MainViewModel: ObservableObject {
	var tasksViewModel = TasksViewModel()
	var settingsViewModel = SettingsViewModel()
}
