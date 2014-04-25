﻿-----------------------------------------------	SCRIPT LIBRARY: TEXT HANDLING----------------------------------------------- HANDLER: Returns absolute value of theNumberon abs(theNumber)	set num to theNumber as integer	if num < 0 then set num to num * -1	return numend abs-----------------------------------------------	Conversion and Encoding----------------------------------------------- HANDLER: Converts string to all upper or lower case--	this_case of 0 yields lower case, 1 upper case--	Only supports English alphabet! Use Shell command for broader support.--	See http://www.mindingthegaps.com/blog/2011/05/26/applescript-converting-uppercase-lowercase-applescrunix-style/on change_case(this_text, this_case)	if this_case is 0 then		set the comparison_string to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"		set the source_string to "abcdefghijklmnopqrstuvwxyz"	else		set the comparison_string to "abcdefghijklmnopqrstuvwxyz"		set the source_string to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"	end if	set the new_text to ""	repeat with this_char in this_text		set x to the offset of this_char in the comparison_string		if x is not 0 then			set the new_text to (the new_text & character x of the source_string) as string		else			set the new_text to (the new_text & this_char) as string		end if	end repeat	return the new_textend change_case-- HANDLER: URL-encodes character--	encode_char(" ") => "%20"--	Source: http://www.macosxautomation.com/applescript/sbrt/sbrt-08.htmlon encode_char(this_char)	set the ASCII_num to (the ASCII number this_char)	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}	set x to item ((ASCII_num div 16) + 1) of the hex_list	set y to item ((ASCII_num mod 16) + 1) of the hex_list	return ("%" & x & y) as stringend encode_char-- HANDLER: Decodes url-encoded string--	decode_text("%20") => " "--	Source: http://www.macosxautomation.com/applescript/sbrt/sbrt-08.htmlon decode_text(this_text)	set flag_A to false	set flag_B to false	set temp_char to ""	set the character_list to {}	repeat with this_char in this_text		set this_char to the contents of this_char		if this_char is "%" then			set flag_A to true		else if flag_A is true then			set the temp_char to this_char			set flag_A to false			set flag_B to true		else if flag_B is true then			set the end of the character_list to my decode_chars(("%" & temp_char & this_char) as string)			set the temp_char to ""			set flag_A to false			set flag_B to false		else			set the end of the character_list to this_char		end if	end repeat	return the character_list as stringend decode_text-- HANDLER: Decodes a three-character hex string--	Source: http://www.macosxautomation.com/applescript/sbrt/sbrt-08.htmlon decode_chars(these_chars)	copy these_chars to {indentifying_char, multiplier_char, remainder_char}	set the hex_list to "123456789ABCDEF"	if the multiplier_char is in "ABCDEF" then		set the multiplier_amt to the offset of the multiplier_char in the hex_list	else		set the multiplier_amt to the multiplier_char as integer	end if	if the remainder_char is in "ABCDEF" then		set the remainder_amt to the offset of the remainder_char in the hex_list	else		set the remainder_amt to the remainder_char as integer	end if	set the ASCII_num to (multiplier_amt * 16) + remainder_amt	return (ASCII character ASCII_num)end decode_chars-- HANDLER: Returns list as text stringto join(theList, delimiter)	set TID to AppleScript's text item delimiters	set AppleScript's text item delimiters to delimiter	set theResult to theList as text	set AppleScript's text item delimiters to TID	return theResultend join-- HANDLER: Removes everything but integers from stringon stripToInteger(someText)	set myResult to {}	set TextItems to text items of (someText as string)	repeat with i in TextItems		try			set end of myResult to (i as integer)		end try	end repeat	myResult as stringend stripToInteger-- HANDLER: Returns list as return-delimited text stringto listToText(theList)	set theText to ""	repeat with i in theList		set myPath to POSIX path of (i as alias)		set theText to theText & myPath & return	end repeat	return theTextend listToText-- HANDLER: Converts record to stringto recordToString(theRecord)	try		theRecord as string	on error errMessage	end try	set recString to textBetween(errMessage, "{", "}")	return "{" & recString & "}"end recordToString-----------------------------------------------	Find and Replace----------------------------------------------- HANDLER: Returns patterncounton patternCount(theText, matchString)	set oldTID to AppleScript's text item delimiters	set AppleScript's text item delimiters to {matchString}	set countedPattern to count of text items of theText	set AppleScript's text item delimiters to oldTID	return countedPattern - 1end patternCount-- HANDLER: Substitutes characters within text stringon replace_chars(this_text, search_string, replacement_string)	set AppleScript's text item delimiters to the search_string	set the item_list to every text item of this_text	set AppleScript's text item delimiters to the replacement_string	set this_text to the item_list as string	set AppleScript's text item delimiters to ""	return this_textend replace_chars-- HANDLER: Splits string into array by delimiterto split(someText, delimiter)	set AppleScript's text item delimiters to delimiter	set someText to someText's text items	set AppleScript's text item delimiters to {""}	return someTextend split-- HANDLER: Searches and replaces string within text block--	Accepts lists in searchString and replaceStringto searchReplaceText(theText, searchString, replaceString)	set searchString to searchString as list	set replaceString to replaceString as list	set theText to theText as text		set oldTID to AppleScript's text item delimiters	repeat with i from 1 to count searchString		set AppleScript's text item delimiters to searchString's item i		set theText to theText's text items		set AppleScript's text item delimiters to replaceString's item i		set theText to theText as text	end repeat	set AppleScript's text item delimiters to oldTID		return theTextend searchReplaceText-- HANDLER: Replaces string in text--	Retrieved from Sean Kehoe, Apple--	Not sure if this offers benefits over changing text item delimiterson findAndReplace(sourceString, searchString, substitutionString)	set lengthOfSearchString to length of searchString	repeat		set positionOfMatch to offset of searchString in sourceString		if positionOfMatch is equal to 0 then			--No more matches.			exit repeat		else if positionOfMatch is 1 then			set sourceString to substitutionString & (characters (positionOfMatch + (length of searchString)) thru (length of sourceString) of sourceString) as string		else if positionOfMatch is equal to (length of sourceString) then			set sourceString to ((characters 1 thru (positionOfMatch - (length of searchString)) of sourceString) as string) & substitutionString		else			set sourceString to ((characters 1 thru (positionOfMatch - 1) of sourceString) as string) & substitutionString & (characters (positionOfMatch + (length of searchString)) thru (length of sourceString) of sourceString) as string		end if	end repeat	return sourceStringend findAndReplace-- HANDLER: Returns text between first occurrences of openDelim and closeDelimon textBetween(theText, openDelim, closeDelim)	if openDelim is "" then		set oStart to 1	else		set oStart to offset of openDelim in theText	end if	if oStart = 0 then return ""	set oStart to oStart + (length of openDelim)	if closeDelim is "" then		set oEnd to (length of theText)	else		set oEnd to offset of closeDelim in (text (oStart + 1) thru (length of theText) of theText)		if oEnd = 0 then return ""		set oEnd to oEnd + oStart - 1	end if	set result to text oStart thru oEnd of theTextend textBetween-- HANDLER: Retrieves text between first occurrences of startString and endStringto textBetween_old(theText, startString, endString)	set oldTID to AppleScript's text item delimiters	set AppleScript's text item delimiters to startString	set theString to item 2 of text items of theText	set AppleScript's text item delimiters to endString	set theString to item 1 of text items of theString	set AppleScript's text item delimiters to oldTID	theStringend textBetween_old-- HANDLER: Returns offset of last occurrence of characteron lastOffset(theString, theCharacter)	set strRev to (reverse of characters of theString) as text	set s to (length of theString) - (offset of theCharacter in strRev) + 1end lastOffset-- HANDLER: Returns offset of last occurrence of character--	Source: http://www.alecjacobson.com/weblog/?p=49on lastOffset2(theText, char)	try		set len to count of theText		set reversed to reverse of characters of theText as string		set last_occurrence to len - (offset of char in reversed) + 1		if last_occurrence > len then			return 0		end if	on error		return 0	end try	return last_occurrenceend lastOffset2-- HANDLER: Trims the provided string from the text's beginningon lstripString(theText, trimString)	set x to count trimString	try		repeat while theText begins with the trimString			set theText to characters (x + 1) thru -1 of theText as text		end repeat	on error		return ""	end try	return theTextend lstripString-- HANDLER: Trims the provided string from the text's endingon rstripString(theText, trimString)	set x to count trimString	try		repeat while theText ends with the trimString			set theText to characters 1 thru -(x + 1) of theText as text		end repeat	on error		return ""	end try	return theTextend rstripString-- HANDLER: Trims the provided string from the text's boundaries-- Note: Requires the lstripString and rstripString functionson stripString(theText, trimString)	set theText to lstripString(theText, trimString)	set theText to rstripString(theText, trimString)	return theTextend stripString-- HANDLER: Returns offset of nth occurrence of character--	Required handlers: abs--	Where theString = "this:dir:path:"--		NthOffset(theString,":d",1,1) = 5--		NthOffset(theString,":",1,6) = 9--		NthOffset(theString,":",-1,1) = 0--		NthOffset(theString,":",-1,-1) = 14--		NthOffset(theString,":",-1,-2) = 9on NthOffset(theString, matchString, occurrence, startPos)	if occurrence < 0 then		set theString to text 1 thru startPos of theString		set startPos to 1		set str to (reverse of characters of theString) as text		set matchString to (reverse of characters of matchString) as text	else		set str to theString	end if	if startPos < 0 then		set pos to (length of theString) + startPos + 1	else		set pos to startPos	end if	repeat with n from 1 to my abs(occurrence)		try			set strCur to text pos thru -1 of str		on error			return 0		end try		set posCur to offset of matchString in strCur		if posCur = 0 then return 0		set pos to pos + posCur	end repeat	set pos to pos - 1	if occurrence < 0 then		set posFinal to (length of theString) - pos + 1	else		set posFinal to pos	end if	return posFinalend NthOffset-- HANDLER: Removes trailing newlinesto trimLinesRight(theText)	repeat while theText ends with return		set theText to theText's text 1 thru -2	end repeat	return theTextend trimLinesRight-- HANDLER: Remove trailing and/or leading characters from stringson trim_line(this_text, trim_chars, trim_indicator)	-- 0 = beginning, 1 = end, 2 = both	set x to the length of the trim_chars	-- TRIM BEGINNING	if the trim_indicator is in {0, 2} then		repeat while this_text begins with the trim_chars			try				set this_text to characters (x + 1) thru -1 of this_text as string			on error				-- the text contains nothing but the trim characters				return ""			end try		end repeat	end if	-- TRIM ENDING	if the trim_indicator is in {1, 2} then		repeat while this_text ends with the trim_chars			try				set this_text to characters 1 thru -(x + 1) of this_text as string			on error				-- the text contains nothing but the trim characters				return ""			end try		end repeat	end if	return this_textend trim_line-- HANDLER: trims unwanted characters from multiple lines--    Requires trim_line sub-routineon trim_paragraphs(this_text, trim_chars, trim_indicator)	set the paragraph_list to every paragraph of this_text	repeat with i from 1 to the count of paragraphs of this_text		set this_paragraph to item i of the paragraph_list		set item i of the paragraph_list to trim_line(this_paragraph, trim_chars, trim_indicator)	end repeat	set AppleScript's text item delimiters to return	set this_text to the paragraph_list as string	set AppleScript's text item delimiters to ""	return this_textend trim_paragraphs-- HANDLER: Strips leading and trailing occurences of supplied characterto stripChar of char from someText	set TID to AppleScript's text item delimiters	set charToRemove to char	set AppleScript's text item delimiters to charToRemove	set TextItems to someText's text items		set a to 1	set b to (count TextItems)		--Determine the first item that is not charToRemove	repeat while (a < b) and ((count item a of TextItems) is 0)		set a to a + 1	end repeat		--Determine last item that is not charToRemove	repeat while (b > a) and ((count item b of TextItems) is 0)		set b to b - 1	end repeat		--Strip leading and trailing charToRemove items	set strippedText to text from text item a to text item b of someText	set AppleScript's text item delimiters to TID	strippedTextend stripChar