//
//  RegistrationsView.swift
//  Lomi
//
//  Created by Chris Worman on 2021-08-23.
//

import SwiftUI

// A screen that allows the user browse their registered Lomi appliances.
struct DeviceRegistrationScreen: View {
    @EnvironmentObject var environment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode
    
    init(initiallySelectedRegistrationId: String) {
        _selectedRegistrationId = State(initialValue: initiallySelectedRegistrationId)
    }
    
    @State var isLoading: Bool = false
    @State var showingError: Bool = false
    @State var error: String = ""
    @State var selectedRegistrationId: String
    @State var isDeleteAsking: Bool = false
    @State var isDeleteCompleting: Bool = false
    
    private let emptyRegistration = Registration(id: "emptyRegistrationId", lomiSerialNumber: "", lomiName: "-----", userId: "", createdAt: "", apiClientDetails: nil)
    
    private var selectedRegistration: Registration {
        return environment.registrations.first(where: { $0.id == selectedRegistrationId }) ?? emptyRegistration
    }
    
    // We do not use `environment.registrations` directly as a source of picker view.
    private var registrationsForPicker: [Registration] {
        return  environment.registrations.isEmpty ? [emptyRegistration] : environment.registrations
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                HStack {
                    Text("My Lomi")
                        .fontWeight(.bold)
                    Spacer()
                    
                    NavigationLink {
                        AddDeviceScreen(
                            viewController: AddDeviceViewController(device: Device()),
                            selectedRegistrationId: $selectedRegistrationId
                        )
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(Color.primarySoftBlack)
                                .font(.system(size: 14))
                            Text("Add a Lomi")
                                .foregroundColor(Color.primarySoftBlack)
                                .font(.system(size: 14))
                        }
                        .background(Color.primaryWhite)
                        .padding(.all, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.secondaryGrey, lineWidth: 1)
                        )
                    }
                    
                }.padding(.horizontal, 16)
                
                MenuPicker(
                     mainTitle: selectedRegistration.lomiName,
                     selectedId: $selectedRegistrationId,
                     titleKeyPath: \Registration.lomiName,
                     items: registrationsForPicker
                )
                    .padding(.horizontal)
                
                if selectedRegistration.id != emptyRegistration.id {
                    EditableCell(
                        destination: {
                            EditDeviceNameScreen(viewModel: EditDeviceNameViewModel(device: Device(registration: selectedRegistration)))
                                .environmentObject(environment)
                        },
                        label: "Device Nickname",
                        text: selectedRegistration.lomiName
                    ).padding(.horizontal, 16)
                    
                    EditableCell(
                        destination: {
                            EditSerialNumberScreen(viewModel: EditSerialNumberViewModel(device:Device(registration: selectedRegistration)))
                                .environmentObject(environment)
                        },
                        label: "Device Serial Number",
                        text: selectedRegistration.lomiSerialNumber
                    ).padding(.horizontal, 16)
                }
                
                VStack(alignment: .leading) {
                    Divider()
                    
                    WebNavigationLink(url: LomiWebLink.warranty.rawValue) {
                        RightArrowCell(text: "Warranty")
                    }.padding(.horizontal, 16)
                    
                    
                    Divider()
                    
                    WebNavigationLink(url: LomiWebLink.support.rawValue) {
                        RightArrowCell(text: "Support")
                    }.padding(.horizontal, 16)
                    
                    Divider()
                }.padding(.bottom, 32)
                
                if selectedRegistration.id != emptyRegistration.id {
                    ButtonDelete(
                        text: "Delete Device",
                        action: {
                            isDeleteAsking = true
                        },
                        fullWidth: false,
                        iconSystemName: "trash.fill"
                    )
                    // Avoid multi request
                        .disabled(isDeleteAsking || isLoading)
                        .padding(.horizontal, 24)
                }
                
            }
            .padding(.top, 32)
            .onAppear(perform: {
                AnalyticsLogger.singleton.logEvent(
                    .screenView,
                    parameters: [.screenName: AnalyticsScreenName.registrations]
                )
            })
            .alert(isPresented: $isDeleteAsking, content: {
                Alert(
                    title: Text("Delete Lomi"),
                    message: Text("Are you sure you want to delete \(selectedRegistration.lomiName)?"),
                    primaryButton: .destructive(Text("OK")) {
                        isLoading = true
                        if let auth = try? environment.getLomiApiAuth() {
                            environment.lomiApi.deleteRegistration(
                                authToken: auth.authToken,
                                registrationId: selectedRegistrationId,
                                onSuccess: { (response: EmptyApiResponse?) -> Void in
                                    let serialPrefix = selectedRegistration.lomiSerialNumber.prefix(6)
                                    AnalyticsLogger.singleton.logEvent(
                                        .registrationDelete,
                                        parameters: [
                                            .itemVariant: String(serialPrefix.prefix(2)), // L# - Lomi version
                                            .itemCategory: String(serialPrefix.suffix(2)) // YY - year
                                        ])
                                    // Go to next confirmation alert.
                                    DispatchQueue.main.async {
                                        isLoading = false
                                        isDeleteCompleting = true
                                    }
                                },
                                onError: { (apiError: LomiApiErrorResponse) -> Void in
                                    isLoading = false
                                    isDeleteAsking = false
                                    environment.handleApiErrorResponse(apiError: apiError)
                                }
                            )
                            
                        }
                    },
                    secondaryButton: .cancel()
                )
            })
            
            // Second alter shown after complete deleting. Text("") is just fake view to attach alert.
            Text("")
                .alert(isPresented: $isDeleteCompleting, content: {
                    Alert(
                        title: Text(""),
                        message: Text("Device deleted"),
                        dismissButton: Alert.Button.default(
                            Text("Ok"),
                            action: {
                                isDeleteCompleting = false
                                // Update Local data. I put it at this timing because once you delete it, it will be force dismiss.
                                environment.registrations.removeAll { $0.id == selectedRegistrationId }
                                
                                selectedRegistrationId = registrationsForPicker.first?.id ?? ""
                            }
                        )
                    )
                })
            
            ProgressModal(showing: isLoading)
        }
    }
}

struct RegistrationsView_Previews: PreviewProvider {
    static var previews: some View {
        // User has more than one device, and select one correctly
        let envWithTwoDevice = PreviewAppEnvironmentBuilder().build()
        DeviceRegistrationScreen(initiallySelectedRegistrationId: envWithTwoDevice.registrations[0].id)
            .environmentObject(envWithTwoDevice)
        
        // User has one device, and select it correctly
        let envWithOneDevice = PreviewAppEnvironmentBuilder().withRegistrations(registrations:[ PreviewAppEnvironmentBuilder.defaultRegistrations[0]]).build()
        DeviceRegistrationScreen(initiallySelectedRegistrationId: envWithOneDevice.registrations[0].id)
            .environmentObject(envWithOneDevice)
        
        // User has no device, wrong id
        let envWithNoDevice = PreviewAppEnvironmentBuilder().withRegistrations(registrations:[]).build()
        DeviceRegistrationScreen(initiallySelectedRegistrationId: "WrongId")
            .environmentObject(envWithNoDevice)
        
        // User has some device, but wrong id
        DeviceRegistrationScreen(initiallySelectedRegistrationId: "WrongId")
            .environmentObject(envWithTwoDevice)
        
        // User has no device, but somehow select an id.
        DeviceRegistrationScreen(initiallySelectedRegistrationId: envWithTwoDevice.registrations[0].id)
            .environmentObject(envWithNoDevice)
    }
}

