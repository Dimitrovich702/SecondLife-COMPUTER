// Requests a text-to-speech sound clip from Bonnie and plays it.
key bonnieBelle86 = "5a6b0045-12db-4bf6-8108-7c27f024ca5b";
string URL = "";

requestTTS(string text) {
    // Truncate text so we don't overflow the llInstantMessage limit.
    text = llBase64ToString(llGetSubString(llStringToBase64(text), 0, 512));

    string message = llList2Json(JSON_OBJECT, [
        "command", "tts",
      //  "voice", "vctk_low#p239",
    "voice", "en_US/ljspeech_low#drunk",
        //"voice", "en_US/hifi-tts_low#angry",
        //"voice", "es_ES/carlfm_low#disgusted",
        //"voice", "en_US/cmu-arctic_low#rms",
        // "voice", "de_DE/thorsten-emotion_low#drunk",
        "body", text,
        "url", URL
    ]);
    
    llInstantMessage(bonnieBelle86, message);
}

default {
    on_rez(integer n) {
        llResetScript();
    }
    attach(key id)
    {
        if(id!=NULL_KEY)llResetScript();
    }
    state_entry() {
        llRequestURL();
        string root_uuid = llList2String(llGetObjectDetails(llGetKey(), [OBJECT_ROOT]), 0);
       llListen(1, "", root_uuid ,  "");
      //  llListen(1, "", llGetOwner(), "");
        llSetTimerEvent(600);
    }
    changed(integer c)
    {
        if(c&CHANGED_REGION)llResetScript();
    }
    listen(integer c, string n, key i, string m) {
        requestTTS(m);
    }
    
    http_request(key id, string method, string body) {
        if (method == URL_REQUEST_GRANTED) {
            URL = body;
        } else {
            llHTTPResponse(id, 200, "OK");
            string sound = llJsonGetValue(body, ["uuid"]);
            float duration = (float)llJsonGetValue(body, ["duration"]);
            llTriggerSound(sound, 1.0);
            llSleep(duration);
        }
    }
    
    timer() {
        llResetScript();
    }
}