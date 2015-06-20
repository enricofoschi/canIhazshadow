class @Crater.Services.ThirdParties.TwilioService extends @Crater.Services.ThirdParties.Base

    _twilio = null
    _number = null

    constructor: (number, sid, token) ->
        @_number = number
        @_twilio = Twilio sid, token

    sendSms: (targetNumber, body) ->
        @_twilio.sendSms {
                to: targetNumber,
                from: @_number,
                body: body
            }, (error, result) ->
                if !error
                    console.log result.from
                    console.log result.body
                else
                    console.log "Error %j", error
                return
