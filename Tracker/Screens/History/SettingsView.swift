import SwiftUI

struct SettingsView: View {
	@ObservedObject var viewModel: SettingsViewModel
	
	var body: some View {
		VStack(spacing: 16) {
			Button("Удалить все задачи") {
				viewModel.removeAllTasks()
			}
			Button("Удалить все проекты") {
				viewModel.removeAllProjects()
			}
		}
		.padding()
	}
}

#Preview {
	SettingsView(viewModel: SettingsViewModel())
}
