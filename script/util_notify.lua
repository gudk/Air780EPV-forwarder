local util_notify = {}

local function urlencodeTab(params)
    local msg = {}
    for k, v in pairs(params) do
        table.insert(msg, string.urlEncode(k) .. "=" .. string.urlEncode(v))
        table.insert(msg, "&")
    end
    table.remove(msg)
    return table.concat(msg)
end

-- 发送到 telegram
local function notifyToTelegram(msg)
    if config.TELEGRAM_PROXY_API == nil or config.TELEGRAM_PROXY_API == "" then
        log.error("util_notify.notifyToTelegram", "未配置 `config.TELEGRAM_PROXY_API`")
        return
    end

    local header = {
        ["content-type"] = "text/plain",
        ["x-disable-web-page-preview"] = "1",
        ["x-chat-id"] = config.TELEGRAM_CHAT_ID or "",
        ["x-token"] = config.TELEGRAM_TOKEN or ""
    }

    log.info("util_notify.notifyToTelegram", "POST", config.TELEGRAM_PROXY_API)
    return http.request("POST", config.TELEGRAM_PROXY_API, header, msg).wait()
end

-- 发送到 pushdeer
local function notifyToPushDeer(msg)
    if config.PUSHDEER_API == nil or config.PUSHDEER_API == "" then
        log.error("util_notify.notifyToPushDeer", "未配置 `config.PUSHDEER_API`")
        return
    end
    if config.PUSHDEER_KEY == nil or config.PUSHDEER_KEY == "" then
        log.error("util_notify.notifyToPushDeer", "未配置 `config.PUSHDEER_KEY`")
        return
    end

    local header = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    local body = {
        pushkey = config.PUSHDEER_KEY or "",
        type = "text",
        text = msg
    }

    log.info("util_notify.notifyToPushDeer", "POST", config.PUSHDEER_API)
    return http.request("POST", config.PUSHDEER_API, header, urlencodeTab(body)).wait()
end

-- 发送到 bark
local function notifyToBark(msg)
    if config.BARK_API == nil or config.BARK_API == "" then
        log.error("util_notify.notifyToBark", "未配置 `config.BARK_API`")
        return
    end
    if config.BARK_KEY == nil or config.BARK_KEY == "" then
        log.error("util_notify.notifyToBark", "未配置 `config.BARK_KEY`")
        return
    end

    local header = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    local body = {
        body = msg
    }
    local url = config.BARK_API .. "/" .. config.BARK_KEY

    log.info("util_notify.notifyToBark", "POST", url)
    return http.request("POST", url, header, urlencodeTab(body)).wait()
end

-- 发送到 dingtalk
local function notifyToDingTalk(msg)
    if config.DINGTALK_WEBHOOK == nil or config.DINGTALK_WEBHOOK == "" then
        log.error("util_notify.notifyToDingTalk", "未配置 `config.DINGTALK_WEBHOOK`")
        return
    end

    local header = {
        ["Content-Type"] = "application/json; charset=utf-8"
    }
    local body = {
        msgtype = "text",
        text = {
            content = msg
        }
    }
    local json_data = json.encode(body)
    -- LuatOS Bug, json.encode 会将 \n 转换为 \b
    json_data = string.gsub(json_data, "\\b", "\\n")

    log.info("util_notify.notifyToDingTalk", "POST", config.DINGTALK_WEBHOOK, json_data)
    return http.request("POST", config.DINGTALK_WEBHOOK, header, json_data).wait()
end

-- 发送到 feishu
local function notifyToFeishu(msg)
    if config.FEISHU_WEBHOOK == nil or config.FEISHU_WEBHOOK == "" then
        log.error("util_notify.notifyToFeishu", "未配置 `config.FEISHU_WEBHOOK`")
        return
    end

    local header = {
        ["Content-Type"] = "application/json; charset=utf-8"
    }
    local body = {
        msg_type = "text",
        content = {
            text = msg
        }
    }
    local json_data = json.encode(body)
    -- LuatOS Bug, json.encode 会将 \n 转换为 \b
    json_data = string.gsub(json_data, "\\b", "\\n")

    log.info("util_notify.notifyToFeishu", "POST", config.FEISHU_WEBHOOK, json_data)
    return http.request("POST", config.FEISHU_WEBHOOK, header, json_data).wait()
end

-- 发送到 wecom
local function notifyToWeCom(msg)
    if config.WECOM_WEBHOOK == nil or config.WECOM_WEBHOOK == "" then
        log.error("util_notify.notifyToWeCom", "未配置 `config.WECOM_WEBHOOK`")
        return
    end

    local header = {
        ["Content-Type"] = "application/json; charset=utf-8"
    }
    local body = {
        msgtype = "text",
        text = {
            content = msg
        }
    }
    local json_data = json.encode(body)
    -- LuatOS Bug, json.encode 会将 \n 转换为 \b
    json_data = string.gsub(json_data, "\\b", "\\n")

    log.info("util_notify.notifyToWeCom", "POST", config.WECOM_WEBHOOK, json_data)
    return http.request("POST", config.WECOM_WEBHOOK, header, json_data).wait()
end

-- 发送到 next-smtp-proxy
local function notifyToNextSmtpProxy(msg)
    if config.NEXT_SMTP_PROXY_API == nil or config.NEXT_SMTP_PROXY_API == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_API`")
        return
    end
    if config.NEXT_SMTP_PROXY_USER == nil or config.NEXT_SMTP_PROXY_USER == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_USER`")
        return
    end
    if config.NEXT_SMTP_PROXY_PASSWORD == nil or config.NEXT_SMTP_PROXY_PASSWORD == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_PASSWORD`")
        return
    end
    if config.NEXT_SMTP_PROXY_HOST == nil or config.NEXT_SMTP_PROXY_HOST == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_HOST`")
        return
    end
    if config.NEXT_SMTP_PROXY_PORT == nil or config.NEXT_SMTP_PROXY_PORT == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_PORT`")
        return
    end
    if config.NEXT_SMTP_PROXY_TO_EMAIL == nil or config.NEXT_SMTP_PROXY_TO_EMAIL == "" then
        log.error("util_notify.notifyToNextSmtpProxy", "未配置 `config.NEXT_SMTP_PROXY_TO_EMAIL`")
        return
    end

    local header = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    local body = {
        user = config.NEXT_SMTP_PROXY_USER,
        password = config.NEXT_SMTP_PROXY_PASSWORD,
        host = config.NEXT_SMTP_PROXY_HOST,
        port = config.NEXT_SMTP_PROXY_PORT,
        form_name = config.NEXT_SMTP_PROXY_FORM_NAME,
        to_email = config.NEXT_SMTP_PROXY_TO_EMAIL,
        subject = config.NEXT_SMTP_PROXY_SUBJECT,
        text = msg
    }

    log.info("util_notify.notifyToNextSmtpProxy", "POST", config.NEXT_SMTP_PROXY_API, urlencodeTab(body))
    return http.request("POST", config.NEXT_SMTP_PROXY_API, header, urlencodeTab(body)).wait()
end

function util_notify.send(msg)
    log.info("util_notify.send", "发送通知", config.NOTIFY_TYPE)

    if type(msg) == "table" then
        msg = table.concat(msg, "\n")
    end
    if type(msg) ~= "string" then
        log.error("util_notify.send", "发送通知失败", "参数类型错误", type(msg))
        return
    end

    local model = hmeta.model() or ""
    local simid = mobile.simid()
    local iccid = mobile.iccid(simid) or ""
    local rsrp = mobile.rsrp()
    local mcc, mnc, band = util_mobile.mcc, util_mobile.mnc, util_mobile.band
    local oper = util_mobile.getOper(true)
    local lat, lng = util_location.getCoord()
    local map_url = "https://apis.map.qq.com/uri/v1/marker?coord_type=1&marker=title:+;coord:" .. lat .. "," .. lng

    msg = msg .. "\n"
    if model then
        msg = msg .. "\nMODEL: " .. model
    end
    if iccid then
        msg = msg .. "\nICCID: " .. iccid
    end
    if oper then
        msg = msg .. "\n运营商: " .. oper
    end
    msg = msg .. "\n信号: " .. rsrp .. "dBm"
    if band ~= "" then
        msg = msg .. "\n频段: B" .. band
    end
    if lat ~= 0 and lng ~= 0 then
        msg = msg .. "\n位置: " .. map_url
    end

    -- 判断通知类型
    local notify
    if config.NOTIFY_TYPE == "telegram" then
        notify = notifyToTelegram
    elseif config.NOTIFY_TYPE == "pushdeer" then
        notify = notifyToPushDeer
    elseif config.NOTIFY_TYPE == "bark" then
        notify = notifyToBark
    elseif config.NOTIFY_TYPE == "dingtalk" then
        notify = notifyToDingTalk
    elseif config.NOTIFY_TYPE == "feishu" then
        notify = notifyToFeishu
    elseif config.NOTIFY_TYPE == "wecom" then
        notify = notifyToWeCom
    elseif config.NOTIFY_TYPE == "next-smtp-proxy" then
        notify = notifyToNextSmtpProxy
    else
        log.error("util_notify.send", "发送通知失败", "未配置 `config.NOTIFY_TYPE`")
        return
    end

    sys.taskInit(
        function()
            sys.wait(100)
            local max_retry = 10
            local retry_count = 0

            while retry_count < max_retry do
                util_netled.blink(50, 50)
                local code, headers, body = notify(msg)
                util_netled.blink()
                if code == 200 then
                    log.info("util_notify.send", "发送通知成功", "retry_count:", retry_count, "code:", code, "body:", body)
                    break
                else
                    retry_count = retry_count + 1
                    log.error("util_notify.send", "发送通知失败", "retry_count:", retry_count, "code:", code, "body:", body)
                    util_netled.blink(500, 200, 3000)
                    sys.wait(10000)
                end
            end
        end
    )
end

return util_notify
