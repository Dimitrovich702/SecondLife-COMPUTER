//start_unprocessed_text
/*integer MULTI_PAGE_DLG_SELECT_NOTECARD = -16001;
integer LINE_MAX_LEN = 96;

integer DISPLAY_STRING      = 204000; 
integer DISPLAY_EXTENDED    = 204001; 
integer REMAP_INDICES       = 204002; 
integer RESET_INDICES       = 204003; 
integer SET_FADE_OPTIONS    = 204004; 
integer SET_FONT_TEXTURE    = 204005; 
integer SET_LINE_COLOR      = 204006; 
integer SET_COLOR           = 204007; 
integer RESCAN_LINKSET      = 204008;
 
/|/internal API
integer REGISTER_SLAVE      = 205000;
integer SLAVE_RECOGNIZED    = 205001;
integer SLAVE_DISPLAY       = 205003;
integer SLAVE_DISPLAY_EXTENDED = 205004;
integer SLAVE_RESET         = 205005;

list format = ["center","left","right"];

list colors = [
    "green", <0.,1.,0.>,
    "red", <1.000, 0.255, 0.212>,
    "yellow", <1.000, 0.863, 0.000>,
    "blue",<0.000, 0.455, 0.851>,
    "white",<1.,1.,1.>,
    "black",<0.,0.,0.>,
    "pink",<1.,0.,1.>,
    "grey",<.5,.5,.5>,
    "orange",<1.,0.5,0.>,
    "navy", <0.000, 0.122, 0.247>,
    "aqua", <0.498, 0.859, 1.000>,
    "silver", <0.867, 0.867, 0.867>,
    "teal", <0.224, 0.800, 0.800>,
    "olive", <0.239, 0.600, 0.439>,
    "lime", <0.004, 1.000, 0.439>,
    "maroon", <0.522, 0.078, 0.294>,
    "purple", <0.694, 0.051, 0.788>];

integer DisplayTextHook     = 100000;
integer DisplayTextHookCool = 100001;

integer dlgChannel;
integer dlgListener;

integer lineNumber;
string notecard;
key ncReader;

BuildNotecardList()
{
    /|/ AVAILABLE_NOTECARDS
    list notecards = [];
    integer i;
    integer limit = llGetInventoryNumber(INVENTORY_NOTECARD);
    for (i = 0; i < limit; ++i)
        notecards += [ llGetInventoryName(INVENTORY_NOTECARD, i) ];
        
    llLinksetDataWrite("AVAILABLE_NOTECARDS", llDumpList2String(notecards, "\n"));
}

ReadNotecard()
{
    if (notecard != "")
    {
        llMessageLinked(LINK_THIS, SET_COLOR, "<1,1,1>", "");
        lineNumber = 0;
        ncReader = llGetNotecardLine(notecard, lineNumber++);
    }
}

StartComms()
{
    dlgChannel = -23500000 + (integer)llFrand(99999.0);
    if (dlgListener != 0)
        llListenRemove(dlgListener);
    dlgListener = llListen(dlgChannel, "", llGetOwner(), "");
}

default
{
    state_entry()
    {
        BuildNotecardList();
        integer i;
        llMessageLinked(LINK_THIS, RESCAN_LINKSET, "                                                                                                ", NULL_KEY);
        for (i = 0; i <= 11; ++i)
        {
            llMessageLinked(LINK_THIS, SET_LINE_COLOR, "<1.0, 1.0, 1.0>", (string)i);
            llMessageLinked(LINK_THIS, DISPLAY_STRING, "", (string)i);
        }
        StartComms();
    }
    on_rez(integer param)
    {
        StartComms();
    }
    changed(integer change)
    {
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_OWNER))
            StartComms();
    }
    touch_start(integer num)
    {
        llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, 0 ], "\n"), llDetectedKey(0));
    }
    listen(integer channel,string name,key id,string message)
    {
        if (channel == dlgChannel) /|/in case you have others listeners
        {
            if (message == "<<")
                llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, -1 ], "\n"), id);
            else if (message == ">>")
                llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, 1 ], "\n"), id);
            else
            {
                integer selectedNum = (integer)message;
                
                notecard = llGetInventoryName(INVENTORY_NOTECARD, selectedNum - 1);
                ReadNotecard();
            }
        }
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        if (num == DisplayTextHook)
        {
            integer lineNumber = (integer)((string)id);
            list data = llParseString2List(msg,["[","]"],[]);   
            integer data_cnt = llGetListLength(data);
            integer color = llListFindList(colors,[llToLower(llList2String(data,-1))]);
            vector col = <1.,1.,1.>;
            if(color != -1 && data_cnt > 1)
            {
                col = llList2Vector(colors,color+1);
                data = llDeleteSubList(data,-1,-1);
                llMessageLinked(LINK_THIS, SET_LINE_COLOR, (string)col, (string)(lineNumber));
            }
    
            data_cnt = llGetListLength(data);
            string Event = llList2String(data,-1);
            string full_empty = "                                                                                                                                                                                                        ";    
            integer fmt = llListFindList(format,[llToLower(llList2String(data,0))]);
            integer len = llStringLength(Event);
            
            if(len > LINE_MAX_LEN)
                len = LINE_MAX_LEN;
            if(fmt != -1 && data_cnt > 1)
            {
                integer diff = LINE_MAX_LEN - len;
                if(fmt == 0)
                {
                    if(diff > 1)
                    {
                        diff = diff/2;
                        Event = llGetSubString(full_empty,0,diff - 1) + Event;                    
                    }            
                }        
                else if(fmt == 1)
                {
                    Event = Event + llGetSubString(full_empty,0,diff - 1);   
                }        
                else if(fmt == 2)
                {
                    if(diff > 1) {            
                        Event = llGetSubString(full_empty,0,diff - 1) + Event;
                    }
                }        
            }
            llMessageLinked(LINK_THIS, DISPLAY_STRING, Event, (string)(lineNumber));
        }
    }
    dataserver(key id, string data)
    {
        if (id == ncReader)
        {
            if (data != EOF)
            {
                llMessageLinked(LINK_THIS, DisplayTextHook, data, (string)(lineNumber - 1));
                
                if (lineNumber < 12)
                    ncReader = llGetNotecardLine(notecard, lineNumber++);
            }
        }
    }
}
*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 6.6.14.69596 - LiamHoffen
//last_compiled 03/05/2024 15:43:47
//mono




integer MULTI_PAGE_DLG_SELECT_NOTECARD = -16001;
integer LINE_MAX_LEN = 96;

integer DISPLAY_STRING      = 204000; 
integer SET_LINE_COLOR      = 204006; 
integer SET_COLOR           = 204007; 
integer RESCAN_LINKSET      = 204008;

list format = ["center","left","right"];

list colors = [
    "green", <0.,1.,0.>,
    "red", <1.000, 0.255, 0.212>,
    "yellow", <1.000, 0.863, 0.000>,
    "blue",<0.000, 0.455, 0.851>,
    "white",<1.,1.,1.>,
    "black",<0.,0.,0.>,
    "pink",<1.,0.,1.>,
    "grey",<.5,.5,.5>,
    "orange",<1.,0.5,0.>,
    "navy", <0.000, 0.122, 0.247>,
    "aqua", <0.498, 0.859, 1.000>,
    "silver", <0.867, 0.867, 0.867>,
    "teal", <0.224, 0.800, 0.800>,
    "olive", <0.239, 0.600, 0.439>,
    "lime", <0.004, 1.000, 0.439>,
    "maroon", <0.522, 0.078, 0.294>,
    "purple", <0.694, 0.051, 0.788>];

integer DisplayTextHook     = 100000;

integer dlgChannel;
integer dlgListener;

integer lineNumber;
string notecard;
key ncReader;

StartComms()
{
    dlgChannel = -23500000 + (integer)llFrand(99999.0);
    if (dlgListener != 0)
        llListenRemove(dlgListener);
    dlgListener = llListen(dlgChannel, "", llGetOwner(), "");
}

ReadNotecard()
{
    if (notecard != "")
    {
        llMessageLinked(LINK_THIS, SET_COLOR, "<1,1,1>", "");
        lineNumber = 0;
        ncReader = llGetNotecardLine(notecard, lineNumber++);
    }
}

BuildNotecardList()
{
    
    list notecards = [];
    integer i;
    integer limit = llGetInventoryNumber(INVENTORY_NOTECARD);
    for (i = 0; i < limit; ++i)
        notecards += [ llGetInventoryName(INVENTORY_NOTECARD, i) ];
        
    llLinksetDataWrite("AVAILABLE_NOTECARDS", llDumpList2String(notecards, "\n"));
}

default
{
    state_entry()
    {
        BuildNotecardList();
        integer i;
        llMessageLinked(LINK_THIS, RESCAN_LINKSET, "                                                                                                ", NULL_KEY);
        for (i = 0; i <= 11; ++i)
        {
            llMessageLinked(LINK_THIS, SET_LINE_COLOR, "<1.0, 1.0, 1.0>", (string)i);
            llMessageLinked(LINK_THIS, DISPLAY_STRING, "", (string)i);
        }
        StartComms();
    }
    on_rez(integer param)
    {
        StartComms();
    }
    changed(integer change)
    {
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_OWNER))
            StartComms();
    }
    touch_start(integer num)
    {
        llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, 0 ], "\n"), llDetectedKey(0));
    }
    listen(integer channel,string name,key id,string message)
    {
        if (channel == dlgChannel) 
        {
            if (message == "<<")
                llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, -1 ], "\n"), id);
            else if (message == ">>")
                llMessageLinked(LINK_THIS, MULTI_PAGE_DLG_SELECT_NOTECARD, llDumpList2String([ dlgChannel, 1 ], "\n"), id);
            else
            {
                integer selectedNum = (integer)message;
                
                notecard = llGetInventoryName(INVENTORY_NOTECARD, selectedNum - 1);
                ReadNotecard();
            }
        }
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        if (num == DisplayTextHook)
        {
            integer lineNumber = (integer)((string)id);
            list data = llParseString2List(msg,["[","]"],[]);   
            integer data_cnt = llGetListLength(data);
            integer color = llListFindList(colors,[llToLower(llList2String(data,-1))]);
            vector col = <1.,1.,1.>;
            if(color != -1 && data_cnt > 1)
            {
                col = llList2Vector(colors,color+1);
                data = llDeleteSubList(data,-1,-1);
                llMessageLinked(LINK_THIS, SET_LINE_COLOR, (string)col, (string)(lineNumber));
            }
    
            data_cnt = llGetListLength(data);
            string Event = llList2String(data,-1);
            string full_empty = "                                                                                                                                                                                                        ";    
            integer fmt = llListFindList(format,[llToLower(llList2String(data,0))]);
            integer len = llStringLength(Event);
            
            if(len > LINE_MAX_LEN)
                len = LINE_MAX_LEN;
            if(fmt != -1 && data_cnt > 1)
            {
                integer diff = LINE_MAX_LEN - len;
                if(fmt == 0)
                {
                    if(diff > 1)
                    {
                        diff = diff/2;
                        Event = llGetSubString(full_empty,0,diff - 1) + Event;                    
                    }            
                }        
                else if(fmt == 1)
                {
                    Event = Event + llGetSubString(full_empty,0,diff - 1);   
                }        
                else if(fmt == 2)
                {
                    if(diff > 1) {            
                        Event = llGetSubString(full_empty,0,diff - 1) + Event;
                    }
                }        
            }
            llMessageLinked(LINK_THIS, DISPLAY_STRING, Event, (string)(lineNumber));
        }
    }
    dataserver(key id, string data)
    {
        if (id == ncReader)
        {
            if (data != EOF)
            {
                llMessageLinked(LINK_THIS, DisplayTextHook, data, (string)(lineNumber - 1));
                
                if (lineNumber < 12)
                    ncReader = llGetNotecardLine(notecard, lineNumber++);
            }
        }
    }
}

