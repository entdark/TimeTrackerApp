import ActivityKit
import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct TrackerLiveActivity: Widget {
	let tint = Color(red: 0.33, green: 0.69, blue: 1.0)
	
	func timerTint(playing: Bool) -> Color { playing ? tint : .secondary }
	func playImageIcon(playing: Bool) -> String { playing ? "pause.fill" : "play.fill" }
	func playImageTint(playing: Bool) -> Color { playing ? tint : .blue }
	func playButtonTint(playing: Bool) -> Color? { playing ? tint : .secondary }
	
	var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrackerAttributes.self) { context in
            // Lock screen/banner UI goes here
			HStack {
				Text("00:00:00")
					.hidden()
					.overlay(alignment: .center) {
						SharedViews.Timer(initialTime: context.state.time, playingDate: context.state.playingDate)
							.font(.system(size: 17))
							.fontWeight(Font.Weight.bold)
							.foregroundStyle(timerTint(playing: context.state.playing))
					}
					.fixedSize(horizontal: true, vertical: true)
					.frame(maxWidth: 80, maxHeight: .infinity, alignment: .center)
				VStack(alignment: .center) {
					if context.state.projectName != nil {
						Spacer()
					}
					Text(context.state.title)
						.lineLimit(1)
						.truncationMode(.tail)
					if let projectName = context.state.projectName {
						HStack(alignment: .center, spacing: 4) {
							if let icon = context.state.projectIcon {
								Image(systemName: icon)
									.foregroundStyle(context.state.projectColor.toColor())
									.imageScale(.small)
							} else if context.state.projectColor != .none {
								Image(systemName: "circle.fill")
									.foregroundStyle(context.state.projectColor.toColor())
									.imageScale(.small)
							}
							Text(projectName)
								.font(.caption)
								.lineLimit(1)
								.truncationMode(.tail)
								.foregroundStyle(.secondary)
						}
					}
				}
				.padding(EdgeInsets(top: context.state.projectName != nil ? 8 : 0, leading: 0, bottom: 0, trailing: 0))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				Button(intent: PlaybackIntent(id: context.attributes.id.uuidString)) {
					Image(systemName: playImageIcon(playing: context.state.playing))
						.imageScale(.medium)
						.foregroundStyle(playImageTint(playing: context.state.playing))
						.frame(width: 24, height: 24)
				}
				.buttonStyle(.bordered)
				.controlSize(.regular)
				.buttonBorderShape(.circle)
				.tint(playButtonTint(playing: context.state.playing))
				.frame(maxWidth: 80, maxHeight: .infinity, alignment: .trailing)
			}
			.padding(16)
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
					Text("00:00:00")
						.hidden()
						.overlay(alignment: .center) {
							SharedViews.Timer(initialTime: context.state.time, playingDate: context.state.playingDate)
								.font(.system(size: 17))
								.fontWeight(Font.Weight.bold)
								.foregroundStyle(timerTint(playing: context.state.playing))
						}
						.fixedSize(horizontal: true, vertical: true)
						.frame(maxWidth: 80, maxHeight: .infinity, alignment: .center)
                }
                DynamicIslandExpandedRegion(.trailing) {
					HStack(alignment: .center) {
						Spacer()
						Button(intent: PlaybackIntent(id: context.attributes.id.uuidString)) {
							Image(systemName: playImageIcon(playing: context.state.playing))
								.imageScale(.medium)
								.foregroundStyle(playImageTint(playing: context.state.playing))
								.frame(width: 24, height: 24)
						}
						.buttonStyle(.bordered)
						.controlSize(.regular)
						.buttonBorderShape(.circle)
						.tint(playButtonTint(playing: context.state.playing))
						.frame(alignment: .trailing)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                DynamicIslandExpandedRegion(.center) {
					VStack(alignment: .center) {
						Text(context.state.title)
							.lineLimit(1)
							.truncationMode(.tail)
						if let projectName = context.state.projectName {
							HStack(alignment: .center, spacing: 4) {
								if let icon = context.state.projectIcon {
									Image(systemName: icon)
										.foregroundStyle(context.state.projectColor.toColor())
										.imageScale(.small)
								} else if context.state.projectColor != .none {
									Image(systemName: "circle.fill")
										.foregroundStyle(context.state.projectColor.toColor())
										.imageScale(.small)
								}
								Text(projectName)
									.font(.caption)
									.lineLimit(1)
									.truncationMode(.tail)
									.foregroundStyle(.secondary)
							}
						} else {
							Text("Helper")
								.font(.caption)
								.lineLimit(1)
								.hidden()
						}
						Spacer()
							.background(.yellow, in: .rect)
							.backgroundStyle(.red)
					}
					.padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } compactLeading: {
				Text("00:00:00")
					.hidden()
					.overlay(alignment: .leading) {
						SharedViews.Timer(initialTime: context.state.time, playingDate: context.state.playingDate)
							.foregroundStyle(timerTint(playing: context.state.playing))
					}
            } compactTrailing: {
				Text("00:00:00")
					.hidden()
					.overlay(alignment: .trailing) {
						Image(systemName: "stopwatch.fill")
							.foregroundStyle(tint)
					}
            } minimal: {
				Image(systemName: "stopwatch.fill")
					.foregroundStyle(tint)
            }
            .keylineTint(tint)
        }
    }
}

extension TrackerAttributes {
    fileprivate static var preview: TrackerAttributes {
		TrackerAttributes(id: UUID(uuid: UUID_NULL))
    }
}

#Preview("Notification", as: .dynamicIsland(.expanded), using: TrackerAttributes.preview) {
	TrackerLiveActivity()
} contentStates: {
	TrackerAttributes.ContentState(task: TaskModel(
		title: "Difficult taskDifficult taskDifficult task",
		time: 400,
		playing: true,
		playingDate: .now - 30000
	))
}
