# Flurry Revenue Sample Application (Swift Version)

This is a Swift sample app based on Flurry Revenue Analytics service. See [ObjC version](https://github.com/flurrydev/Flurry-iOS-revenue-analytics-sample-ObjC) here. Flurry Revenue Analtyics can help log transactions for you and present a real-time chart in Flurry Portal.

Detailed instructions are written in [Yahoo Developer Network Website](https://developer.yahoo.com/flurry/docs/analytics/gettingstarted/revenue/ios/). Two modes are available to developers. One is auto integration and the other is manual integration. In the auto mode, you have to set ``setIAPReportingEnabled`` to true. Flurry will take care of adding/removing transaction observer and transacation logging. In the manual mode, set ``setIAPReportingEnabled`` to false. Flurry provide an API called ``logPayment`` to help you log transactions you want.
