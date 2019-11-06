# HealthKitSample

A start of a pedometer application.

This application:
1. Detects user motion using `CoreMotion`
2. On motion, queries `HealthKit` for the amount of steps taken today
3. Updates that value on the UI.


# TODO

* May want to explore using `CMPedometer`?

#  Resources

[Setting up HealthKit](https://developer.apple.com/documentation/healthkit/setting_up_healthkit)


[Getting today's steps](https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps)
