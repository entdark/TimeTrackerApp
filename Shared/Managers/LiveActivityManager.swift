import ActivityKit
import Foundation

public final class LiveActivityManager {
	public static let shared = LiveActivityManager()
	
	public func startOrUpdate(task: TaskModel, forceUpdate: Bool = false) async {
		guard ActivityAuthorizationInfo().areActivitiesEnabled else {
			return
		}
		
		let state = TrackerAttributes.ContentState(task: task)
		let activities = Activity<TrackerAttributes>.activities
		let activity = activities.first { activity in
			activity.attributes.id == task.id
		}
		if let activity {
			let oldState = activity.content.state
			if oldState == state {
				return
			}
			await activity.update(ActivityContent<Activity<TrackerAttributes>.ContentState>(
				state: state, staleDate: nil
			), alertConfiguration: nil)
		} else if !forceUpdate {
			do {
				if !activities.isEmpty {
					await stopAll()
				}
				let attributes = TrackerAttributes(id: task.id)
			 
				let activity = try Activity.request(
					attributes: attributes,
					content: .init(state: state, staleDate: nil),
					pushType: nil
				)
			} catch {
				let errorMessage = """
					Couldn't start activity
					------------------------
					\(String(describing: error))
					"""
				
				print(errorMessage)
			}
		}
	}
	
	public func stopAll() async {
		guard ActivityAuthorizationInfo().areActivitiesEnabled else {
			return
		}
		
		let activities = Activity<TrackerAttributes>.activities
		
		for activity in activities {
			let state = TrackerAttributes.ContentState(task: TaskModel())
			let dismissalPolicy = ActivityUIDismissalPolicy.after(.now)
			await activity.end(ActivityContent<Activity<TrackerAttributes>.ContentState>(
				state: state, staleDate: nil
			), dismissalPolicy: dismissalPolicy)
		}
	}
	
	public func stop(task: TaskModel) async {
		guard ActivityAuthorizationInfo().areActivitiesEnabled else {
			return
		}
		
		let state = TrackerAttributes.ContentState(task: task)
		let activities = Activity<TrackerAttributes>.activities
		let activity = activities.first { activity in
			activity.attributes.id == task.id
		}
		if let activity {
			let oldState = activity.content.state
			if oldState == state {
				return
			}
			let dismissalPolicy = ActivityUIDismissalPolicy.after(.now)
			await activity.end(ActivityContent<Activity<TrackerAttributes>.ContentState>(
				state: state, staleDate: nil
			), dismissalPolicy: dismissalPolicy)
		}
	}
}
