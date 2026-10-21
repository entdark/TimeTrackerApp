import SwiftUI

struct TasksView: View {
	@State private var showTask: Bool = false
	@State private var selectedTask: TaskItemViewModel? = nil
	
	@ObservedObject var viewModel: TasksViewModel
	
	var body: some View {
		NavigationStack {
			ZStack {
				Rectangle()
					.fill(Color(uiColor: .secondarySystemBackground))
					.ignoresSafeArea()
				if !viewModel.tasks.isEmpty {
					List(viewModel.tasks) { task in
						TaskItemView(viewModel: task)
							.listRowSeparator(.hidden)
							.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
							.listRowBackground(Color.clear)
							.onTapGesture {
								selectedTask = task
							}
					}
					.listStyle(.plain)
				} else {
					VStack(alignment: .center) {
						VStack(alignment: .center, spacing: 4) {
							Text("Задач пока не было")
								.multilineTextAlignment(.center)
								.font(.title2)
								.foregroundStyle(.secondary)
							Text("Нажмите 􀊕 Быстрый старт для начала отслеживания времени или создайте новую задачу")
								.padding(.horizontal, 36)
								.multilineTextAlignment(.center)
								.font(.body)
								.foregroundStyle(.tertiary)
						}
						.frame(maxHeight: .infinity)
						Button() {
							viewModel.startNewTask()
						} label: {
							HStack(alignment: .center ,spacing: 8) {
								Image(systemName: "play.circle")
									.imageScale(.large)
								Text("Быстрый старт")
							}
							.frame(maxWidth: .infinity)
						}
						.buttonStyle(.glassProminent)
						.controlSize(.large)
						.padding(16)
					}
				}
			}
			.toolbarTitleDisplayMode(.inlineLarge)
			.navigationTitle("Задачи")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Start", systemImage: "play.circle") {
						viewModel.startNewTask()
					}
				}
				ToolbarSpacer(.fixed, placement: .topBarTrailing)
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add", systemImage: "plus") {
						showTask.toggle()
					}
					.sheet(isPresented: $showTask) {
						NavigationStack {
							TaskView(viewModel: TaskViewModel()) { task in
								viewModel.addNewTask(task: task)
							}
						}
					}
				}
			}
			.sheet(item: $selectedTask) { task in
				NavigationStack {
					TaskDetailsView(viewModel: TaskDetailsViewModel(task: task)) { task in
						viewModel.refresh(task: task)
					}
				}
				.presentationDetents([.medium])
			}
		}
	}
}

#Preview {
	TasksView(viewModel: TasksViewModel())
}
