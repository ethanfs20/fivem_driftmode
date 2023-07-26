Config = {
    permissionsBased = false,
    permissionName = 'driftmode.use',
    -- https://forum.cfx.re/t/basic-aces-principals-overview-guide/90917

    vehicleWhitelist = false,
    models = {"adder"},
    -- https://docs.fivem.net/docs/game-references/vehicle-models/

    vehicleClassWhitelist = false,
    classes = {0, 1, 2, 3, 4, 5, 6, 7},
    -- https://docs.fivem.net/natives/?_0x29439776AAA00A62

    keybind = true,
    startKey = 38,

    twostep = false,
    handleMods = {
        {"fInitialDragCoeff", 90.22}, {"fDriveInertia", .31},
        {"fSteeringLock", 22}, {"fTractionCurveMax", -1.1},
        {"fTractionCurveMin", -.4}, {"fTractionCurveLateral", 2.5},
        {"fLowSpeedTractionLossMult", -.57}
    }
}
