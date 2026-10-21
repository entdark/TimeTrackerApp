import SwiftUI

struct TaskDetailsView: View {
	@State private var showTask: Bool = false
	
	@Environment(\.scenePhase) private var scenePhase
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var viewModel: TaskDetailsViewModel
	var resultAction: ((TaskViewModel) -> ())?
	
	var body: some View {
		ZStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 8) {
					Text(viewModel.title)
						.font(.title3)
						.frame(maxWidth: .infinity, alignment: .leading)
					if let project = viewModel.project {
						HStack(alignment: .center, spacing: 4) {
							if let icon = project.icon {
								Image(systemName: icon)
									.foregroundStyle(project.color.toColor())
									.imageScale(.small)
							} else if project.color != .none {
								Image(systemName: "circle.fill")
									.foregroundStyle(project.color.toColor())
									.imageScale(.small)
							}
							Text(project.title)
								.font(.caption)
								.foregroundStyle(.secondary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
					Text(viewModel.details)
						.font(.body)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				.padding(16)
			}
			VStack {
				Spacer()
				Button("Перейти к сводке") {
					showTask.toggle()
				}
				.frame(alignment: .bottom)
				.sheet(isPresented: $showTask) {
					NavigationStack {
						TaskView(viewModel: viewModel.editingViewModel, editing: true) { task in
							viewModel.update(task: task)
							resultAction?(task)
						}
					}
				}
			}
		}
		.toolbarTitleDisplayMode(.inline)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				if viewModel.playing {
					Button("Pause", systemImage: "pause.fill") {
						viewModel.pause()
					}
				} else {
					Button("Play", systemImage: "play.fill") {
						viewModel.play()
					}
					.buttonStyle(.glassProminent)
				}
			}
			ToolbarItem(placement: .title) {
				SharedViews.Timer(initialTime: viewModel.time, playingDate: viewModel.playingDate)
					.font(.largeTitle)
			}
		}
		.onChange(of: scenePhase) { oldValue, newValue in
			switch newValue {
			case .active:
				viewModel.checkPlayback()
			default:
				break
			}
		}
	}
}

#Preview {
	NavigationStack {
		TaskDetailsView(viewModel: TaskDetailsViewModel(/*model: TaskModel(title: "heh")*/))
	}
}
