//
//  EditProjectView.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/9/21.
//
import CloudKit
import CoreHaptics
import CoreData
import SwiftUI
import UserNotifications

struct EditProjectView: View {
    enum CloudStatus {
        case checking, exists, absent
    }
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var engine = try? CHHapticEngine()


    @AppStorage("username") var username: String?
    @State private var showingSignIn = false

    @State private var cloudStatus = CloudStatus.checking
    @State private var cloudError: CloudError?

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }

    }
    var body: some View {
        Form {
            // sec 1
            Section(header: Text("Basic settings")) {
                /* Original code */
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))

                // Code to use if problem continues
             //   TextField("Project name", text: $title)
             //   TextField("Description of this project", text: $detail)

            }
            // sec 2
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section(header: Text("Project reminders")) {
                Toggle(
                    "Show Reminders", isOn:
                        $remindMe.animation())
                    .alert("Ughh", isPresented: $showingNotificationsError) {
                        #if os(iOS)
                        Button("Check Settings", action: showAppSettings)
                        #endif
                        Button("OK") { }
                    } message: {
                        Text(
                        "Make sure notifications are enabled")
                    }

                if remindMe {
                    DatePicker(
                        "Reminder Time", selection: $reminderTime,
                        displayedComponents: .hourAndMinute)
                }
            }
            // sec 3
            Section(footer: Text("Closing a project moves it from the Open to Closed tab")) {
                Button(project.closed ? "Reopen project?" : "Close the project", action: toggleClosed)
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(title: Text(
                            "Delete project?"), message: Text(
                                "Are you sure?"), primaryButton: .default(Text(
                                "Delete"), action: delete), secondaryButton: .cancel())
                }
            }
        }
        .navigationTitle("Edit Project")
        .toolbar {
            switch cloudStatus {
            case .checking:
                    ProgressView()
            case .exists:
                    Button {
                        removeFromCloud(deleteLocal: false)
                    } label: {
                        Label("Remove from iCloud", systemImage: "icloud.slash")
                    }
            case .absent:
                    Button(action: uploadToCloud) {
                        Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                    }
            }
        }
        // This is used to fix
      //  .onDisappear(perform: update)

        // Add this back when code bug gets fixed
        .onAppear(perform: updateCloudStatus)
        .onDisappear(perform: dataController.save)
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localizedMessage)
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }


    func toggleClosed() {
            project.closed.toggle()
            if project.closed {
                #if os(iOS)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                #endif
                do {
                    try engine?.start()
                    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                    let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                    let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                    let parameter = CHHapticParameterCurve(
                        parameterID: .hapticIntensityControl,
                        controlPoints: [start, end],
                        relativeTime: 0)

                    let event1 = CHHapticEvent(
                        eventType: .hapticTransient,
                        parameters: [intensity, sharpness],
                        relativeTime: 0)

                    let event2 = CHHapticEvent(
                        eventType: .hapticContinuous,
                        parameters: [sharpness, intensity],
                        relativeTime: 0.125, duration: 1)
                    let pattern = try CHHapticPattern(
                        events: [event1, event2],
                        parameterCurves: [parameter])
                    let player = try engine?.makePlayer(with: pattern)
                    try player?.start(atTime: 0)
                } catch {
                    // didn't work
                }
        }
    }


    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }

        // new addition to be removed after it works
       // dataController.save()
        //
    }

    func delete() {
        if cloudStatus == .exists {
            removeFromCloud(deleteLocal: true)
        } else {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }

        .onTapGesture {
            color = item

            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    #if os(iOS)
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    #endif

    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys

            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    cloudError = error.getCloudKitError()
                }
                updateCloudStatus()
            }

            cloudStatus = .checking

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }
    func updateCloudStatus() {
        project.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }

    func removeFromCloud(deleteLocal: Bool) {
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                cloudError = error.getCloudKitError()
            } else {
                if deleteLocal {
                    dataController.delete(project)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            updateCloudStatus()
        }
        cloudStatus = .checking
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
/* The problem seem to be with update(). I found a work-a-round for time being is to

 remove .onChange(update) from both TextFields
 remove update() from .onTapGesture in colorButton
 add dataController.save() to func update()
 change .onDisappear to .onDisappear(perform: update)
*/

/*  Button {
    let records = project.prepareCloudRecords()
    let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
    operation.savePolicy = .allKeys
    operation.modifyRecordsCompletionBlock = { _, _, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }
    CKContainer.default().publicCloudDatabase.add(operation)
   } label: {
   Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
  } */
