local util_netled = {}

local netled = gpio.setup(27, 0, gpio.PULLUP)

local netled_default_duration = 200
local netled_default_interval = 2000

local netled_duration = netled_default_duration
local netled_interval = netled_default_interval

sys.taskInit(
    function()
        while true do
            netled(1)
            sys.waitUntil("NET_LED_UPDATE", netled_duration)
            netled(0)
            sys.waitUntil("NET_LED_UPDATE", netled_interval)
        end
    end
)

function util_netled.blink(duration, interval, restore)
    netled_duration = duration or netled_default_duration
    netled_interval = interval or netled_default_interval
    log.info("publish NET_LED_UPDATE")
    sys.publish("NET_LED_UPDATE")
    if restore then
        sys.timerStart(
            function()
                netled_duration = netled_default_duration
                netled_interval = netled_default_interval
                log.info("publish NET_LED_UPDATE")
                sys.publish("NET_LED_UPDATE")
            end,
            restore
        )
    end
end

return util_netled
