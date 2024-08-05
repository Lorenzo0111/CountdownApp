//
//  AppIntent.swift
//  CountdownWidget
//
//  Created by Lorenzo on 05/08/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Widget configuration")

    @Parameter(title: "Countdown Id", default: 0)
    var countdownId: Int
}
