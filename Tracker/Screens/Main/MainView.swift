import SwiftUI

struct MainView: View {
	@ObservedObject var viewModel: MainViewModel
	
	var body: some View {
		TabView {
			Tab("Задачи", systemImage: "list.bullet") {
				TasksView(viewModel: viewModel.tasksViewModel)
			}
			Tab("Настройки", systemImage: "gear") {
				SettingsView(viewModel: viewModel.settingsViewModel)
			}
		}
	}
}

#Preview {
	MainView(viewModel: MainViewModel())
}
