//start_unprocessed_text
/*integer MULTI_PAGE_DLG_SELECT_NOTECARD = -16001;

integer REZZED_SCENE_STRIDE = 5;    /|/ elevation, scene name, scene rezzer UUID, scene rezzer channel, isRezzed

list       gListFullNames;            /|/ List of inventory textures
list       gListBriefNames;           /|/ List of abbreviated texture names for dialog buttons

integer    gPage;                     /|/ Current dialog page number (counting from zero)
integer    gMaxPage;                  /|/ Highest page number (counting from zero)
integer    gChan;                     /|/ Channel used for dialog communications.
key        gUser;                     /|/ Current user accessing the dialogs

integer lastLinkMsgNum;

BuildDialogPage(key user, string hint)
{
    integer TotalChoices = (gListBriefNames != [] );        /|/ get length of texture list

    /|/ set up scrolling buttons if needed
    list buttons = [ "<<", "Back", ">>" ];
    
    integer ChoicesPerPage = 9;
    if (TotalChoices < 12)
    {
        buttons = [ "Back" ];
        ChoicesPerPage = 11;
    }
    /|/ Compute number of menu pages that will be available
    gMaxPage = (TotalChoices - 1) / ChoicesPerPage;
    /|/ Build a dialog menu for current page for given user
    integer start = ChoicesPerPage * gPage;       /|/ starting offset into action list for current page
    /|/ 'start + ChoicesPerPage -1' might point beyond the end of the list -
    /|/ - but LSL stops at the list end, without throwing a wobbly

    string msg = "";

    msg += "\nPage " + (string) (gPage+1) + " of " + (string) (gMaxPage + 1);
    
    msg += "\n" + hint + ":\n";
    
    list text = llList2List(gListFullNames, start, start + ChoicesPerPage - 1);
    msg += "\n" + llDumpList2String(text, "\n");
    
    buttons += llList2List(gListBriefNames, start, start + ChoicesPerPage - 1);
    
    llDialog(user, msg, buttons, gChan);
}

default
{
    state_entry()
    {
        gPage = 0;
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        if (num == MULTI_PAGE_DLG_SELECT_NOTECARD)
        {
            if (lastLinkMsgNum != num)
            {
                gPage = 0;
                lastLinkMsgNum = num;
            }

            integer delta = 0;
            
            list info = llParseStringKeepNulls(msg, [ "\n" ], []);
            if (llGetListLength(info) == 2)
                delta = (integer)llList2Integer(info, 1);
                
            gChan = (integer)llList2String(info, 0);
            gUser = id;
            
            gListFullNames = llParseString2List(llLinksetDataRead("AVAILABLE_NOTECARDS"), [ "\n" ], []);
            gListBriefNames = [];
            
            integer numProducts = llGetListLength(gListFullNames);
            integer i;
            for (i = 0; i < numProducts; ++i)
            {
                string prodName = llList2String(gListFullNames, i);
                
                gListFullNames = llListReplaceList(gListFullNames, [ (string)(i + 1) + ": " + prodName ], i, i);
                gListBriefNames += [ (string)(i + 1) ];
            }

            gPage += delta;            
            if (gPage < 0)          gPage = gMaxPage;     /|/ cycle around pages
            if (gPage > gMaxPage)   gPage = 0;
            BuildDialogPage(gUser, "Select a notecard:");
        }
    }
}*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 6.6.14.69596 - LiamHoffen
//last_compiled 03/05/2024 15:17:33
//mono




integer MULTI_PAGE_DLG_SELECT_NOTECARD = -16001;    

list       gListFullNames;            
list       gListBriefNames;           

integer    gPage;                     
integer    gMaxPage;                  
integer    gChan;                     
key        gUser;                     

integer lastLinkMsgNum;

BuildDialogPage(key user, string hint)
{
    integer TotalChoices = (gListBriefNames != [] );        

    
    list buttons = [ "<<", "Back", ">>" ];
    
    integer ChoicesPerPage = 9;
    if (TotalChoices < 12)
    {
        buttons = [ "Back" ];
        ChoicesPerPage = 11;
    }
    
    gMaxPage = (TotalChoices - 1) / ChoicesPerPage;
    
    integer start = ChoicesPerPage * gPage;       
    
    

    string msg = "";

    msg += "\nPage " + (string) (gPage+1) + " of " + (string) (gMaxPage + 1);
    
    msg += "\n" + hint + ":\n";
    
    list text = llList2List(gListFullNames, start, start + ChoicesPerPage - 1);
    msg += "\n" + llDumpList2String(text, "\n");
    
    buttons += llList2List(gListBriefNames, start, start + ChoicesPerPage - 1);
    
    llDialog(user, msg, buttons, gChan);
}

default
{
    state_entry()
    {
        gPage = 0;
    }
    link_message(integer sender, integer num, string msg, key id)
    {
        if (num == MULTI_PAGE_DLG_SELECT_NOTECARD)
        {
            if (lastLinkMsgNum != num)
            {
                gPage = 0;
                lastLinkMsgNum = num;
            }

            integer delta = 0;
            
            list info = llParseStringKeepNulls(msg, [ "\n" ], []);
            if (llGetListLength(info) == 2)
                delta = (integer)llList2Integer(info, 1);
                
            gChan = (integer)llList2String(info, 0);
            gUser = id;
            
            gListFullNames = llParseString2List(llLinksetDataRead("AVAILABLE_NOTECARDS"), [ "\n" ], []);
            gListBriefNames = [];
            
            integer numProducts = llGetListLength(gListFullNames);
            integer i;
            for (i = 0; i < numProducts; ++i)
            {
                string prodName = llList2String(gListFullNames, i);
                
                gListFullNames = llListReplaceList(gListFullNames, [ (string)(i + 1) + ": " + prodName ], i, i);
                gListBriefNames += [ (string)(i + 1) ];
            }

            gPage += delta;            
            if (gPage < 0)          gPage = gMaxPage;     
            if (gPage > gMaxPage)   gPage = 0;
            BuildDialogPage(gUser, "Select a notecard:");
        }
    }
}
