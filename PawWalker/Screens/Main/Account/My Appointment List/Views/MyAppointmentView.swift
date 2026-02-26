//
//  MyAppointmentView.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI

struct MyAppointmentView: View {
    var myAppointmentData : MyAppointments
    var body: some View {
        VStack (alignment : .leading){
            HStack {
                MyAppoinmentLabel(name: TextResource.pet, value: myAppointmentData.petName ?? "")
                Spacer()
                Text(myAppointmentData.status?.uppercased() ?? "")
                    .foregroundStyle(Color.white)
                    .font(FontConstants.primaryRegularTitle12)
                    .makeBackgroundView(color : Color(ColorResource.primaryButton),
                                        horizontalPadding: 15,verticalPadding: 5)
            }
            HStack {
                VStack(alignment : .leading) {
                    MyAppoinmentLabel(name: TextResource.docter, value: myAppointmentData.doctor ?? "")
                    MyAppoinmentLabel(name: TextResource.clinic, value: myAppointmentData.clinicDetails?.clinicName ?? "")
                }
                Spacer()
                VStack(alignment : .leading) {
                    MyAppoinmentLabel(name: TextResource.time, value: "\(myAppointmentData.startTime ?? "") - \(myAppointmentData.endTime ?? "")")
                    MyAppoinmentLabel(name: TextResource.date, value: myAppointmentData.date ?? "")
                }
            }
        }
        .makeBackgroundView(color: ColorContants.lightLittleGray)
    
    }
}

struct MyAppoinmentLabel : View {
    var name : String
    var value : String
    var body : some View {
        HStack {
            Text("\(name):")
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(ColorContants.dateGray)
            Text(value)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(ColorContants.dateGray)
        }
    }
}

