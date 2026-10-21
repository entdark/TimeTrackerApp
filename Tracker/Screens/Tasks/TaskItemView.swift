import SwiftUI

struct TaskItemView: View {
	@Environment(\.scenePhase) private var scenePhase
	
	@ObservedObject var viewModel: TaskItemViewModel
	
	var playButtonTint: Color? { viewModel.playing ? .blue : nil }
	
	var body: some View {
		ZStack {
			Group {
				HStack(alignment: .center) {
					VStack(alignment: .leading, spacing: 4) {
						Text(viewModel.title)
							.font(.body)
							.fixedSize(horizontal: false, vertical: true)
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
					}
					Spacer()
					Button() {
						viewModel.togglePlayback()
					} label: {
						let image = !viewModel.playing ? "play.fill" : "pause.fill"
						Image(systemName: image)
							.imageScale(.medium)
							.frame(width: 24, height: 24)
						
					}
					.buttonStyle(.bordered)
					.controlSize(.regular)
//					.controlSize(.large)
//					.scaleEffect(x: 0.8, y: 0.8, anchor: .center)
					.buttonBorderShape(.circle)
					.tint(playButtonTint)
				}
				.padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
				.frame(maxWidth: .infinity, minHeight: 78, maxHeight: .infinity)
				.background(.background, in: RoundedRectangle(cornerRadius: 10))
				.backgroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
			TimerView(viewModel: viewModel)
				   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
				   .padding(.trailing, 8)
		}
		.frame(maxWidth: .infinity)
		.onChange(of: scenePhase) { oldValue, newValue in
			switch newValue {
			case .active:
				viewModel.checkPlayback()
			default:
				break
			}
		}
//		.background(.background, in: .rect)
//		.backgroundStyle(Color(uiColor: .red))
	}
}

struct TimerView: View {
	@ObservedObject var viewModel: TaskItemViewModel
	
	var textColor: Color { viewModel.playing ? .blue : .secondary }
	
	var body: some View {
		return SharedViews.Timer(initialTime: viewModel.time, playingDate: viewModel.playingDate)
			.font(.caption)
			.fontWeight(.semibold)
			.frame(width: 98, height: 24, alignment: .center)
			.background(.background, in: .capsule)
			.backgroundStyle(Color(uiColor: .secondarySystemBackground))
			.overlay {
				RoundedRectangle(cornerRadius: 12)
					.strokeBorder(.white, lineWidth: 1.5)
			}
			.foregroundStyle(textColor)
	}
}

#Preview {
	TaskItemView(viewModel: TaskItemViewModel(model: TaskModel(
		title: "Разработка нового логоРазработка нового логоРазработка нового лого",
		details: "Оренбургский пуховый платок",
		time: 69,
		playing: false,
		playingDate: .now - 30,
	)))
}
