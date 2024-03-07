//////////////////////////////////////////// 
// XyzzyText v2.1m (16-Char MESH) by Traven Sachs 29-November-2012
// XyzzyText v2.1(10-Char) by Thraxis Epsilon
// XyzzyText v2.1 Script (Set Line Color) by Huney Jewell
// XyzzyText v2.0 Script (5 Face, Single Texture) 
//
// Heavily Modified by Thraxis Epsilon, Gigs Taggart 5/2007 and Strife Onizuka 8/2007
// Rewrite to allow one-script-per-object operation w/ optional slaves
// Enable prim-label functionality
// Enabled Banking
// Enabled 10-char per prim
// Enabled 16-Char on an 8 Face Mesh Plane Prim
//
// Modified by Kermitt Quirk 19/01/2006 
// To add support for 5 face prim instead of 3 
// 
// Core XyText Originally Written by Xylor Baysklef 
//
//////////////////////////////////////////// 
 
/////////////// CONSTANTS /////////////////// 
// XyText Message Map. 
integer DISPLAY_STRING      = 204000; 
integer DISPLAY_EXTENDED    = 204001; 
integer REMAP_INDICES       = 204002; 
integer RESET_INDICES       = 204003; 
integer SET_FADE_OPTIONS    = 204004; 
integer SET_FONT_TEXTURE    = 204005; 
integer SET_LINE_COLOR      = 204006; 
integer SET_COLOR           = 204007; 
integer RESCAN_LINKSET      = 204008;
 
//internal API
integer REGISTER_SLAVE      = 205000;
integer SLAVE_RECOGNIZED    = 205001;
integer SLAVE_DISPLAY       = 205003;
integer SLAVE_DISPLAY_EXTENDED = 205004;
integer SLAVE_RESET         = 205005;
 
// This is an extended character escape sequence.
string  ESCAPE_SEQUENCE = "\\e";
 
// This is used to get an index for the extended character.
string  EXTENDED_INDEX  = "123456789abcdef";
 
 
// Face numbers. 
integer FACE_1          = 0; 
integer FACE_2          = 1; 
integer FACE_3          = 2; 
integer FACE_4          = 3; 
integer FACE_5          = 4;
integer FACE_6          = 5;
integer FACE_7          = 6;
integer FACE_8          = 7;
 
 
// Used to hide the text after a fade-out. 
key     TRANSPARENT     = "f54a0c32-3cd1-d49a-5b4f-7b792bebc204";
key     null_key        = NULL_KEY;
 
// This is a list of textures for all 2-character combinations. 
list    CHARACTER_GRID  = [ 
"4fd88538-b872-1155-a8d4-4a13e1db0b19", 
"5b8ed51a-fbd7-fb21-ddbb-4096d8a6f903", 
"ee02e022-1aad-c09b-c875-f72a853f07f1", 
"94c3e34e-2f3d-b8bc-4055-ba78990f6b9b", 
"cfce6077-8d59-9509-7853-c55211269d64", 
"8a241229-7af6-4478-7d7b-e8a8af02dd98", 
"c1737b3d-7c4d-ac0b-81ab-bdce1d2272f0", 
"b542f97f-de46-0e8f-4d87-5e21ed1cb93e", 
"9a9e4657-0638-de12-a0a2-eb915924c9fe", 
"9a9e4657-0638-de12-a0a2-eb915924c9fe", 
"b152ae1d-fdae-9fce-3ec8-3bfe7745035a", 
"79c2d0a7-a7f6-0343-5c7a-745fb07d8b0e", 
"3259082e-05d0-47c0-998a-0c4e8195f5d7", 
"2db8f913-6424-9eac-9978-7c44490f9881", 
"13cb4347-841f-1c83-0184-9f4bd54774dd", 
"5e7872b7-e9ca-b0aa-f947-39171fd82a43", 
"c2752edc-d487-e5a1-cc24-be1acb971e6a", 
"d7d4bc9c-f09a-5fac-d53a-7905816fc677", 
"0c1d2c81-de02-428f-6df3-b3ce9ca60374", 
"90314cdc-9b0a-7c75-73a3-7c1f76dc27e1", 
"c386b2ff-99c8-d948-ea6c-bab8635909f6", 
"76151492-f4ad-fcb6-dece-d2a0d784a8a0", 
"ef22f434-267e-e243-c448-bc2f27fd0e26", 
"fa3d4c65-e428-0836-2537-ae54563f73ca", 
"f7cf9eed-b924-1a52-7e0c-81b2eee8d1f4", 
"cfc5a292-740c-b768-827b-55056ac85c16", 
"da532d13-095b-a4d8-c362-7263ea3041f2", 
"dca3d6da-0110-7e24-b120-8cb244a30031", 
"a3776b9b-2138-3fe7-9a15-84eb8bb5e873", 
"df47bd61-61f0-acb6-20d7-5a05ff66ed51", 
"f5e21001-8ade-86f6-e185-0bcc7acab6fa", 
"ed109025-c1e7-3144-5b78-5edf71b92a80", 
"acf5a1ee-86fe-d76e-e929-248fbd42d267", 
"1d615df8-592a-f557-f30a-e92bafb4e947", 
"09639dd1-26e3-faaa-ab6c-d79d65aec752", 
"a7a67d5c-431c-d3d5-ccc7-f99fe0ae1ecb", 
"9bc9a4ca-3d86-68e8-adfc-50a73c6d9ac5", 
"751ca944-3b53-fdfb-6ace-b58497c78776", 
"322ca3f5-2409-3ed1-9041-568e57655375", 
"ccd641c3-ac30-7492-6974-72c9aa389032", 
"9376be0f-cbef-28b6-eb3c-6933a1a77205", 
"629a57a7-d57d-6b0f-b203-4f96a0c941b6", 
"c374a296-1abc-422f-84e6-36d1b6ec5773", 
"a58b602b-d922-815e-9cf4-cea2f33dad3f", 
"965d0e21-0854-7890-116e-0be984c0b8f3", 
"e9ecf924-0cef-1a50-a9ef-23033ad21065", 
"bbc28ad4-6603-ea05-f4d6-5e3b50d34ba5", 
"1dfd3f58-0a54-9ba5-d509-feeaf1f74ea5", 
"2202b656-76ad-eb15-7bad-3bf3ad88ddef", 
"f16680e7-46e1-ceb2-04b8-1bc65dbf7829", 
"97a4baf6-3fa7-0faf-ffd8-5a7955c65a89", 
"06922790-a5e0-86f7-9ccb-2c552513b164", 
"44223891-b719-68ce-8a7a-7a76c7ab8e59", 
"b3d12280-adef-6a62-267a-ff8af63ca125", 
"2ab8a8d3-274a-6e91-acb6-20a742bb72f4", 
"a3873fac-2403-c3d2-4f85-5b393d96a7ff", 
"aa0051aa-3f22-5eab-97b1-ed490405e40b", 
"125060a3-5197-9bfa-7327-cf06c24d59fc", 
"71cb1413-cd27-cb2c-7100-fdff8acebebe", 
"ed108148-9949-fa19-91ed-ef3660ae74ba", 
"96da79d8-fadc-0750-7262-9e688b00beb2", 
"0b6bde2c-b95e-6e34-9c24-9663d621bae1", 
"fc61698c-c89f-34ba-31d5-d823b0f690b5", 
"e6006ccd-dbac-1939-4d2a-094d2243405d", 
"6a879c3e-c960-dd93-b582-ec2a93c86ae4", 
"c74fb175-98ed-03dd-68be-9cb1a89dea26"];
list    CHARACTER_GRID2  = [         
        "f6e41cf2-1104-bd0b-0190-dffad1bac813", 
        "2b4bb15e-956d-56ae-69f5-d26a20de0ce7", 
        "f816da2c-51f1-612a-2029-a542db7db882", 
        "345fea05-c7be-465c-409f-9dcb3bd2aa07", 
        "b3017e02-c063-5185-acd5-1ef5f9d79b89", 
        "4dcff365-1971-3c2b-d73c-77e1dc54242a" 
          ]; 
 
///////////// END CONSTANTS ////////////////
 
///////////// GLOBAL VARIABLES /////////////// 
// All displayable characters.  Default to ASCII order. 
string gCharIndex; 
// This is the channel to listen on while acting 
// as a cell in a larger display. 
integer gCellChannel      = -1; 
// This is the starting character position in the cell channel message 
// to render. 
integer gCellCharPosition = 0;
// This is whether or not to use the fade in/out special effect. 
integer gCellUseFading      = FALSE; 
// This is how long to display the text before fading out (if using 
// fading special effect). 
// Note: < 0  means don't fade out. 
float   gCellHoldDelay      = 1.0; 
 
integer gSlaveRegistered;
list gSlaveNames;
 
integer BANK_STRIDE = 3; //offset, length, highest_dirty
list gBankingData;
 
/////////// END GLOBAL VARIABLES //////////// 
 
ResetCharIndex() { 
    gCharIndex  = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`"; 
    // \" <-- Fixes LSL syntax highlighting bug. 
    gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~"; 
    gCharIndex += "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"; 
} 
 
vector GetGridPos(integer index1, integer index2) { 
    // There are two ways to use the lookup table... 
    integer Col; 
    integer Row; 
    if (index1 >= index2) { 
        // In this case, the row is the index of the first character: 
        Row = index1; 
        // And the col is the index of the second character (x2) 
        Col = index2 * 2; 
    } 
    else { // Index1 < Index2 
        // In this case, the row is the index of the second character: 
        Row = index2; 
        // And the col is the index of the first character, x2, offset by 1. 
        Col = index1 * 2 + 1; 
    } 
    return <Col, Row, 0>; 
} 
 
string GetGridTexture(vector grid_pos) { 
    // Calculate the texture in the grid to use. 
    integer GridCol = llRound(grid_pos.x) / 20; 
    integer GridRow = llRound(grid_pos.y) / 10; 
 
    // Lookup the texture. 
    key Texture = llList2Key(CHARACTER_GRID, GridRow * (GridRow + 1) / 2 + GridCol); 
    return Texture; 
} 
 
vector GetGridOffset(vector grid_pos) { 
    // Zoom in on the texture showing our character pair. 
    integer Col = llRound(grid_pos.x) % 20; 
    integer Row = llRound(grid_pos.y) % 10; 
 
    // Return the offset in the texture. 
    return <-0.45 + 0.05 * Col, 0.45 - 0.1 * Row, 0.0>; 
} 
 
ShowChars(integer link,vector grid_pos1, vector grid_pos2, vector grid_pos3, vector grid_pos4, vector grid_pos5, vector grid_pos6, vector grid_pos7, vector grid_pos8) { 
   // Set the primitive textures directly. 
 
//integer face, string name, vector repeats, vector offsets, float rotation                
   llSetLinkPrimitiveParamsFast( link , [ 
        PRIM_TEXTURE, FACE_1, GetGridTexture(grid_pos1), <0.1, 0.1, 0>, GetGridOffset(grid_pos1), 0.0, 
        PRIM_TEXTURE, FACE_2, GetGridTexture(grid_pos2), <0.1, 0.1, 0>, GetGridOffset(grid_pos2), 0.0, 
        PRIM_TEXTURE, FACE_3, GetGridTexture(grid_pos3), <0.1, 0.1, 0>, GetGridOffset(grid_pos3), 0.0, 
        PRIM_TEXTURE, FACE_4, GetGridTexture(grid_pos4), <0.1, 0.1, 0>, GetGridOffset(grid_pos4), 0.0, 
        PRIM_TEXTURE, FACE_5, GetGridTexture(grid_pos5), <0.1, 0.1, 0>, GetGridOffset(grid_pos5), 0.0,
        PRIM_TEXTURE, FACE_6, GetGridTexture(grid_pos6), <0.1, 0.1, 0>, GetGridOffset(grid_pos6), 0.0,
        PRIM_TEXTURE, FACE_7, GetGridTexture(grid_pos7), <0.1, 0.1, 0>, GetGridOffset(grid_pos7), 0.0,
        PRIM_TEXTURE, FACE_8, GetGridTexture(grid_pos8), <0.1, 0.1, 0>, GetGridOffset(grid_pos8), 0.0 
        ]); 
}
 
RenderString(integer link, string str) {
    // Get the grid positions for each pair of characters. 
    vector GridPos1 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 0, 0)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 1, 1)) ); 
    vector GridPos2 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 2, 2)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 3, 3)) ); 
    vector GridPos3 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 4, 4)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 5, 5)) ); 
    vector GridPos4 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 6, 6)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 7, 7)) ); 
    vector GridPos5 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 8, 8)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 9, 9)) );
    vector GridPos6 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 10, 10)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 11, 11)) );
    vector GridPos7 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 12, 12)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 13, 13)) );
    vector GridPos8 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 14, 14)), 
                                  llSubStringIndex(gCharIndex, llGetSubString(str, 15, 15)) );                                   
 
    // Use these grid positions to display the correct textures/offsets. 
    ShowChars(link,GridPos1, GridPos2, GridPos3, GridPos4, GridPos5, GridPos6, GridPos7, GridPos8); 
}
 
//RenderWithEffects(integer link, string str) { 
//    // Get the grid positions for each pair of characters. 
//    vector GridPos1 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 0, 0)), 
//                                  llSubStringIndex(gCharIndex, llGetSubString(str, 1, 1)) ); 
//    vector GridPos2 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 2, 2)), 
//                                  llSubStringIndex(gCharIndex, llGetSubString(str, 3, 3)) ); 
//    vector GridPos3 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 4, 4)), 
//                                  llSubStringIndex(gCharIndex, llGetSubString(str, 5, 5)) ); 
//    vector GridPos4 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 6, 6)), 
//                                  llSubStringIndex(gCharIndex, llGetSubString(str, 7, 7)) ); 
//    vector GridPos5 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 8, 8)), 
//                                  llSubStringIndex(gCharIndex, llGetSubString(str, 9, 9)) );                          //         
//
//      // First set the alpha to the lowest possible. 
//   llSetAlpha(0.05, ALL_SIDES); 
//
//    // Use these grid positions to display the correct textures/offsets. 
//    ShowChars(link,GridPos1, GridPos2, GridPos3, GridPos4, GridPos5);
//
//    float Alpha = 0.10; 
//    for (; Alpha <= 1.0; Alpha += 0.05)  
//       llSetAlpha(Alpha, ALL_SIDES); 
//          // See if we want to fade out as well. 
//   if (gCellHoldDelay < 0.0) 
//       // No, bail out. (Just keep showing the string at full strength). 
//       return; 
//          // Hold the text for a while. 
//   llSleep(gCellHoldDelay); 
//      // Now fade out. 
//   for (Alpha = 0.95; Alpha >= 0.05; Alpha -= 0.05) 
//       llSetAlpha(Alpha, ALL_SIDES); 
//          // Make the text transparent to fully hide it. 
//   llSetTexture(TRANSPARENT, ALL_SIDES); 
//} 
 
integer RenderExtended(integer link, string str,integer render) {
    // Look for escape sequences.
    integer length = 0;
    list Parsed       = llParseString2List(str, [], (list)ESCAPE_SEQUENCE);
    integer ParsedLen = llGetListLength(Parsed);
 
    // Create a list of index values to work with.
    list Indices;
    // We start with room for 6 indices.
    integer IndicesLeft = 16;
 
    string Token;
    integer Clipped;
    integer LastWasEscapeSequence = FALSE;
    // Work from left to right.
    integer i=0;
    for (; i < ParsedLen && IndicesLeft > 0; ++i) {
        Token = llList2String(Parsed, i);
 
        // If this is an escape sequence, just set the flag and move on.
        if (Token == ESCAPE_SEQUENCE) {
            LastWasEscapeSequence = TRUE;
        }
        else { // Token != ESCAPE_SEQUENCE
            // Otherwise this is a normal token.  Check its length.
            Clipped = FALSE;
            integer TokenLength = llStringLength(Token);
            // Clip if necessary.
            if (TokenLength > IndicesLeft) {
                TokenLength = llStringLength(Token = llGetSubString(Token, 0, IndicesLeft - 1));
                IndicesLeft = 0;
                Clipped = TRUE;
            }
            else
                IndicesLeft -= TokenLength;
 
            // Was the previous token an escape sequence?
            if (LastWasEscapeSequence) {
                // Yes, the first character is an escape character, the rest are normal.
                length += 2 + TokenLength;
                if (render)
                {
                    // This is the extended character.
                    Indices += [llSubStringIndex(EXTENDED_INDEX, llGetSubString(Token, 0, 0)) + 95];
 
                    // These are the normal characters.
                    integer j=1;
                    for (; j < TokenLength; ++j)
                    {
                        Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
                    }
                }
            }
            else { // Normal string.
                // Just add the characters normally.
                length += TokenLength;
                if(render)
                {
                    integer j=0;
                    for (; j < TokenLength; ++j)
                    {
                        Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
                    }
                }
            }
 
            // Unset this flag, since this was not an escape sequence.
            LastWasEscapeSequence = FALSE;
        }
    }
 
    if(render)
    {
        // Use the indices to create grid positions.
        vector GridPos1 = GetGridPos( llList2Integer(Indices, 0), llList2Integer(Indices, 1) );
        vector GridPos2 = GetGridPos( llList2Integer(Indices, 2), llList2Integer(Indices, 3) );
        vector GridPos3 = GetGridPos( llList2Integer(Indices, 4), llList2Integer(Indices, 5) );
        vector GridPos4 = GetGridPos( llList2Integer(Indices, 6), llList2Integer(Indices, 7) );
        vector GridPos5 = GetGridPos( llList2Integer(Indices, 8), llList2Integer(Indices, 9) );
        vector GridPos6 = GetGridPos( llList2Integer(Indices, 10), llList2Integer(Indices, 11) );
        vector GridPos7 = GetGridPos( llList2Integer(Indices, 12), llList2Integer(Indices, 13) );
        vector GridPos8 = GetGridPos( llList2Integer(Indices, 14), llList2Integer(Indices, 15) );
 
        // Use these grid positions to display the correct textures/offsets.
        ShowChars(link, GridPos1, GridPos2, GridPos3, GridPos4, GridPos5, GridPos6, GridPos7, GridPos8);
    }
    return length;
}
 
 
integer ConvertIndex(integer index) {
    // This converts from an ASCII based index to our indexing scheme.
    if (index >= 32) // ' ' or higher
        index -= 32;
    else { // index < 32
        // Quick bounds check.
        if (index > 15)
            index = 15;
 
        index += 94; // extended characters
    }
 
    return index;
}
 
 
PassToRender(integer render,string message, integer bank)
{
    float time;
    integer extendedlen = 0;
    integer link;
 
    integer i = 0;
    integer msgLen = llStringLength(message);
    llSay(1, message); 
    string TextToRender;
    integer num_slaves=llGetListLength(gSlaveNames);
    string slave_name; //avoids unnecessary casts, keeping it as a string
 
 
    //get the bank offset and length
    integer bank_offset=llList2Integer(gBankingData, (bank * BANK_STRIDE));
    integer bank_length=llList2Integer(gBankingData, (bank * BANK_STRIDE) + 1);
    integer bank_highest_dirty=llList2Integer(gBankingData, (bank * BANK_STRIDE) + 2);
 
    integer x=0;    
    for (;x < msgLen;x = x + 16)
    {
 
        if (i >= bank_length)  //we don't want to run off the end of the bank
        {
            //set the dirty to max, and bail out, we're done
            gBankingData=llListReplaceList(gBankingData, [bank_length], (bank * BANK_STRIDE) + 2, (bank * BANK_STRIDE) + 2);
            return;
        }   
 
        link = unpack(gXyTextPrims,(i + bank_offset));
        TextToRender = llGetSubString(message, x, x + 32);
 
        if(gSlaveRegistered && (link % (num_slaves +1)))
        {
            slave_name=llList2String(gSlaveNames, (link % (num_slaves + 1)) - 1);
            if (render == 1)
                llMessageLinked(LINK_THIS, SLAVE_DISPLAY, TextToRender, (key)((string)link + "," + slave_name));
            if (render == 2)
            {
                if(llSubStringIndex(TextToRender,"\e")>x+16)
                {
                    extendedlen = 16;
                }
                else
                {
                    extendedlen = RenderExtended(link,TextToRender,0);
                }
 
                if(extendedlen>16)
                {
                    x += extendedlen-16;
                }
 
                llMessageLinked(LINK_THIS,SLAVE_DISPLAY_EXTENDED,TextToRender,(key)((string)link+","+slave_name));
            }        
        }
        else
        {
            if (render == 1)
                RenderString(link,TextToRender);
            if (render == 2)
            {
                extendedlen = RenderExtended(link,TextToRender,1);
                if(extendedlen>16)
                {
                    x += extendedlen-16;
                }
            }
 
//            if (render == 3)
//                RenderWithEffects(link,TextToRender);
        }
        ++i;            
    }
 
    if (bank_highest_dirty==0)
        bank_highest_dirty=bank_length;
 
    integer current_highest_dirty=i;
    while (i < bank_highest_dirty)
    {
        link = unpack(gXyTextPrims,(i + bank_offset));
 
        if(gSlaveRegistered && (link % (num_slaves+1) != 0))
        {
            slave_name=llList2String(gSlaveNames, (link % (num_slaves + 1)) - 1);
            llMessageLinked(LINK_THIS, SLAVE_DISPLAY, "     ", (key)((string)link + "," + slave_name));       
            //sorry, no fade effect with slave
        }
        else
        {
            RenderString(link,"          ");
        }
        ++i;        
    }
    gBankingData=llListReplaceList(gBankingData, [current_highest_dirty], (bank * BANK_STRIDE) + 2, (bank * BANK_STRIDE) + 2);
}
 
// Bitwise Voodoo by Gigs Taggart and optimized by Strife Onizuka
list gXyTextPrims;
 
 
integer get_number_of_prims()
{//ignores avatars.
    integer a = llGetNumberOfPrims();
    while(llGetAgentSize(llGetLinkKey(a)))
        --a;
    return a;
}
 
//functions to pack 8-bit shorts into ints
list pack_and_insert(list in_list, integer pos, integer value)
{
//    //figure out the bitpack position
//    integer pack = pos & 3; //4 bytes per int
//    pos=pos >> 2;
//    integer shifted = value << (pack << 3);
//    integer old_value = llList2Integer(in_list, pos);
//    shifted = old_value | shifted;
//    in_list = llListReplaceList(in_list, (list)shifted, pos, pos);
//    return in_list;
    //Safe optimized version
    integer index = pos >> 2;
    return llListReplaceList(in_list, (list)(llList2Integer(in_list, index) | (value << ((pos & 3) << 3))), index, index);
}
 
integer unpack(list in_list, integer pos)
{
    return (llList2Integer(in_list, pos >> 2) >> ((pos & 3) << 3)) & 0x000000FF;//unsigned
//    return (llList2Integer(in_list, pos >> 2) << (((~pos) & 3) << 3)) >> 24;//signed
}
 
 
change_color(vector color)
{
    integer num_prims=llGetListLength(gXyTextPrims) << 2;
 
    integer i = 0;
 
    for (; i<=num_prims; ++i)
    {
        integer link = unpack(gXyTextPrims,i);
        if (!link)
            return;
 
        llSetLinkPrimitiveParamsFast( link,[ 
            PRIM_COLOR, FACE_1, color, 1.0,
            PRIM_COLOR, FACE_2, color, 1.0,
            PRIM_COLOR, FACE_3, color, 1.0,
            PRIM_COLOR, FACE_4, color, 1.0,
            PRIM_COLOR, FACE_5, color, 1.0,
            PRIM_COLOR, FACE_6, color, 1.0,
            PRIM_COLOR, FACE_7, color, 1.0,
            PRIM_COLOR, FACE_8, color, 1.0            
        ]);
    }
}
 
change_line_color(integer bank, vector color)
{    
 
    //get the bank offset and length
    integer i = llList2Integer(gBankingData, (bank * BANK_STRIDE));
    integer bank_end = i + llList2Integer(gBankingData, (bank * BANK_STRIDE) + 1);
 
    for (; i < bank_end; ++i)
    {     
        integer link = unpack(gXyTextPrims,i);
        if (!link)
            return;
 
        llSetLinkPrimitiveParamsFast( link,[ 
            PRIM_COLOR, FACE_1, color, 1.0,
            PRIM_COLOR, FACE_2, color, 1.0,
            PRIM_COLOR, FACE_3, color, 1.0,
            PRIM_COLOR, FACE_4, color, 1.0,
            PRIM_COLOR, FACE_5, color, 1.0,
            PRIM_COLOR, FACE_6, color, 1.0,
            PRIM_COLOR, FACE_7, color, 1.0,
            PRIM_COLOR, FACE_8, color, 1.0
        ]);
    }
}
 
init()
{
    integer num_prims=get_number_of_prims();
 
    string link_name;
    integer bank=0;
    integer bank_empty=FALSE;
    integer prims_pointer=0; //"pointer" to the next entry to be used in the gXyTextPrims list.
 
    list temp_bank=[];
    integer temp_bank_stride=2;
 
 
    gXyTextPrims=[];
    integer x=0;
    for (;x<64;++x)
    {
        gXyTextPrims= (gXyTextPrims = []) + gXyTextPrims + [0];  //we need to pad out the list to make it easier to add things in any order later
    }
 
    @loop;
 
    {
 
        //loop over all prims, looking for ones in the current bank
        for(x=0;x<=num_prims;++x)
        {
            link_name=llGetLinkName(x);
            list tmp = llParseString2List(link_name, ["-"], []);
            if(llList2String(tmp,0)== "xyzzytext")
            {
                integer prims_bank=llList2Integer(tmp,1);
                if (llList2Integer(tmp,1)==bank)
                {
                    temp_bank+=llList2Integer(tmp,2) + (list)x;
                }
            }
 
        }
 
 
        if (temp_bank!=[])
        {
            //sort the current bank
            temp_bank=llListSort(temp_bank, temp_bank_stride, TRUE);
 
            integer temp_len=llGetListLength(temp_bank);
 
            //store metadata
            gBankingData+=[prims_pointer,temp_len/temp_bank_stride,0];
 
            //repack the bank into the prim list
            for (x=0; x < temp_len; x+=temp_bank_stride)
            {
                gXyTextPrims = pack_and_insert(gXyTextPrims, prims_pointer, llList2Integer(temp_bank, x+1));
                ++prims_pointer;
            }
            ++bank;
            temp_bank=[];
            jump loop;
        }
    }
 
    llMessageLinked(LINK_THIS, SLAVE_RESET, "" , null_key);
}
 
default { 
    state_entry() { 
        // Initialize the character index. 
        ResetCharIndex();
        init();
    } 
 
   on_rez(integer num)
   {
      llResetScript();       
   }
 
    link_message(integer sender, integer channel, string data, key id) {
        if(id == null_key)
            id="0";
 
        if (channel == DISPLAY_STRING) { 
            PassToRender(1,data, (integer)((string)id)); 
            return; 
        } 
        else if (channel == DISPLAY_EXTENDED) { 
             PassToRender(2,data, (integer)((string)id)); 
            return; 
        }
        else if (channel == REMAP_INDICES) {
            // Parse the message, splitting it up into index values.
            list Parsed = llCSV2List(data);
            integer i;
            // Go through the list and swap each pair of indices.
            for (i = 0; i < llGetListLength(Parsed); i += 2) {
                integer Index1 = ConvertIndex( llList2Integer(Parsed, i) );
                integer Index2 = ConvertIndex( llList2Integer(Parsed, i + 1) );
 
                // Swap these index values.
                string Value1 = llGetSubString(gCharIndex, Index1, Index1);
                string Value2 = llGetSubString(gCharIndex, Index2, Index2);
 
                gCharIndex = llDeleteSubString(gCharIndex, Index1, Index1);
                gCharIndex = llInsertString(gCharIndex, Index1, Value2);
 
                gCharIndex = llDeleteSubString(gCharIndex, Index2, Index2);
                gCharIndex = llInsertString(gCharIndex, Index2, Value1);
            }
            return;
        }
        else if (channel == RESET_INDICES) {
            // Restore the character index back to default settings.
            ResetCharIndex();
            return;
        }        
        else if (channel == RESCAN_LINKSET)
        {
            init();
        }
        else if (channel == SET_COLOR) {
            change_color((vector)data); 
        }
        else if (channel == SET_LINE_COLOR) {
            change_line_color((integer)((string)id), (vector)data); 
        }     
        else if (channel == REGISTER_SLAVE)
        {
            if(!~llListFindList(gSlaveNames, (list)data))
            {//isn't registered yet
                gSlaveNames += data;
                gSlaveRegistered=TRUE;
                //llOwnerSay((string)llGetListLength(gSlaveNames) + " Slave(s) Recognized: " + data);
            }
//            else
//            {//it already exists
//                llOwnerSay((string)llGetListLength(gSlaveNames) + " Slave, Existing Slave Recognized: " + data);
//            }
            llMessageLinked(LINK_THIS, SLAVE_RECOGNIZED, data , null_key);
        }
    }
 
    changed(integer change)
    {
        if(change&CHANGED_INVENTORY)
        {
            if(gSlaveRegistered)        
            {
                //by using negative indexes they don't need to be adjusted when an entry is deleted.
                integer x = ~llGetListLength(gSlaveNames);
                while(++x)
                {
                    if (!~llGetInventoryType(llList2String(gSlaveNames, x)))
                    {
                              llResetScript();  
                        //llOwnerSay("Slave Removed: " + llList2String(gSlaveNames, x));
                        gSlaveNames = llDeleteSubList(gSlaveNames, x, x);
                    }
                }
                gSlaveRegistered = !(gSlaveNames == []);
            }
        }
    }
}