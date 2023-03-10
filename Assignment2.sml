fun deciding(state : int*int*int*int*int*char*char*char) = #1 state = 0;
fun reading(state : int*int*int*int*int*char*char*char) = #1 state = 1;
fun ignoring(state : int*int*int*int*int*char*char*char) = #1 state = ~1;
fun linkactive(state : int*int*int*int*int*char*char*char) = (#5 state div 32) mod 2 = 1;
fun indentation(state : int*int*int*int*int*char*char*char) = #2 state;
fun headingactive(state : int*int*int*int*int*char*char*char) = #3 state>0;
fun listactive(state : int*int*int*int*int*char*char*char) = #4 state > 0;
fun boldactive(state : int*int*int*int*int*char*char*char) = #5 state mod 2 = 1;
fun italicactive(state : int*int*int*int*int*char*char*char) = (#5 state div 2) mod 2 = 1;
fun underlineactive(state : int*int*int*int*int*char*char*char) = (#5 state div 4) mod 2 = 1;
fun paragraphactive(state : int*int*int*int*int*char*char*char) = (#5 state div 8) mod 2 = 1;
fun tableactive(state : int*int*int*int*int*char*char*char) = (#5 state div 16) mod 2 = 1;
fun addquote(n : int, s : string) = if n = 0 then s else addquote(n - 1,  "<blockquote>" ^ s);
fun endquote(n : int, s : string)= if n = 0 then s else endquote(n - 1, s ^ "</blockquote>");
fun deacactivateindentation(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((1, 0, #3 state, #4 state, #5 state, #6 state, #7 state, #8 state), endquote(#2 state,""), l, lout);
fun increaseheadinglevel(state : int*int*int*int*int*char*char*char,l : char list,lout : string list) =((0, #2 state, #3 state + 1, #4 state, #5 state, #6 state, #7 state, #8 state),"", l ,lout);
fun addheading(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ( (1,#2 state,#3 state,#4 state, #5 state, #6 state, #7 state, #8 state), "<h" ^ Int.toString(#3 state) ^ ">", l,lout);
fun deactivateheading(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((1, #2 state, 0, #4 state, #5 state, #6 state, #7 state, #8 state),"</h" ^ Int.toString(#3 state) ^ ">", l,lout );
fun activatecodeblock(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((~1, #2 state, #3 state, #4 state, #5 state, #6 state, #7 state, #8 state),"<pre><code>",l,lout);
fun deactivatecodeblock(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state, #6 state, #7 state, #8 state),"</code></pre>\n",l,lout);
fun checkdigit(c : char)= ord(c) > 47 andalso ord(c) < 58;
fun activatelist(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((#1 state, #2 state, #3 state, 1, #5 state, #6 state, #7 state, #8 state),"", l,lout);
fun addorderedlist(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((#1 state, #2 state, #3 state, (#4 state)*2 + 1, #5 state, #6 state, #7 state, #8 state),"<ol><li>", l ,lout);
fun addunorderedlist(state : int*int*int*int*int*char*char*char, l : char list,lout : string list) = ((#1 state, #2 state, #3 state, (#4 state)*2, #5 state, #6 state, #7 state, #8 state),"<ul><li>", l,lout);
fun checkforlist(l : char list) = if l=[] then (false,l) else if hd(l)= #"." then (true,tl(l)) else if checkdigit(hd(l)) then checkforlist(tl(l)) else (false,l);
fun checklist(l : char list) = let val temp=checkforlist(l) in #1 temp end;
fun sepratelist(l : char list) = let val temp= checkforlist(l) in #2 temp end;
fun endpreviouslist(state : int*int*int*int*int*char*char*char,l : char list,lout : string list) = if (#4 state div 2) mod 2 = 1 then 
if #4 state mod 2 = 1 then ((#1 state, #2 state, #3 state, 0, #5 state, #6 state, #7 state, #8 state),"</ol>", l,lout)
else ((#1 state, #2 state, #3 state, 0, #5 state, #6 state, #7 state, #8 state),"</ul>", l,lout)
else if #4 state mod 2 = 1 then ((#1 state, #2 state, #3 state, #4 state div 2, #5 state, #6 state, #7 state, #8 state),"</ol>", l,lout)
else ((#1 state, #2 state, #3 state, #4 state div 2, #5 state, #6 state, #7 state, #8 state),"</ul>", l,lout); 
fun activatebold(state : int*int*int*int*int*char*char*char,l : char list,lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state + 1, #6 state, #7 state, #8 state),"<b>",l,lout);
fun deactivatebold(state : int*int*int*int*int*char*char*char,l : char list,lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state - 1, #6 state, #7 state, #8 state),"</b>",l,lout);
fun activateitalic(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state + 2, #6 state, #7 state, #8 state),"<i>", l,lout);
fun deactivateitalic(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state - 2, #6 state, #7 state, #8 state),"</i>",l,lout);
fun activateunderline(state : int*int*int*int*int*char*char*char,l : char list, lout : string list) = ((#1 state, #2 state, #3 state, #4 state, (#5 state div 8)*8 + 4 + #5 state mod 4, #6 state, #7 state, #8 state),"<u>",l,lout);
fun findword(w,l,s)= if l=[] orelse hd(l)= #"]" orelse hd(l)= #"\n" then (w,l,s) else findword(w^Char.toString(hd(l)),tl(l),s);
fun findlink(w,l,s)= if l=[] orelse hd(l)= #"\n" then (w, #"\n"::l,s) else if hd(l)= #"]" then (w,tl(l),s) else findlink(w,tl(l),s^Char.toString(hd(l)));
fun linkerrorcheck(w,l,s)= if l=[] then (w, #"\n"::l,s) else if tl(l)=[] then (w, #"\n"::l,s) else if tl(tl(l))=[] then (w, #"\n"::l,s) else if hd(l)= #"]" andalso hd(tl(l))= #"[" then findlink(w,tl(tl(l)),s) else (w, #"\n"::l,s);
fun linkdeactivate(state : int*int*int*int*int*char*char*char,s : string , l : char list, lout : string list) = ((#1 state, #2 state, #3 state, #4 state, #5 state - 32, #6 state, #7 state, #8 state),s^"</a>", l, lout);
fun createlink(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = let val temp=findlink(linkerrorcheck(findword("",l,""))) in linkdeactivate(state,"<a href=\""^ #3 temp ^ "\">" ^ #1 temp,#2 temp,lout) end;
fun activatelink(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = createlink((#1 state, #2 state, #3 state, #4 state, (#5 state div 64)*64 + 32 + #5 state mod 32, #6 state, #7 state, #8 state), l,lout);
fun deactivateunderline(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((#1 state, #2 state, #3 state, #4 state, #5 state - 4, #6 state, #7 state, #8 state),"</u>", l,lout);
fun activateparagraph(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((1, #2 state, #3 state, #4 state, (#5 state div 16)*16 + 8 + #5 state mod 8,#"\n", #6 state, #7 state),"<p>", #8 state :: l,lout);
fun deactivateparagraph(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((1, #2 state, #3 state, #4 state, #5 state - 8, #6 state, #7 state, #8 state),"</p>", l,lout);
fun activatetable(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = let val s= if l=[] then ("Error5",l) else if hd(l)<> #"\n" then ("<TR><TD>",l) else ("",tl(l)) in ((#1 state, #2 state, #3 state, #4 state, (#5 state div 32)*32 + 16 + #5 state mod 16, #6 state, #7 state, #8 state),"<CENTER><TABLE border="^Int.toString(1)^">" ^ #1 s, #2 s,lout) end
fun tabledeactivate(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = ((#1 state, #2 state, #3 state, #4 state, #5 state - 16, #6 state, #7 state, #8 state),"</TABLE></CENTER>", l,lout);
fun indent(state : int*int*int*int*int*char*char*char,n, l : char list, lout : string list) = case l of
[] => if n > #2 state then let val temp1 = if underlineactive(state)  then deactivateunderline(state, l,lout) else (state,"", l,lout)
val temp2 = if boldactive(#1 temp1) then deactivatebold(#1 temp1, #3 temp1,#4 temp1) else (#1 temp1,"", #3 temp1, #4 temp1)
val temp3 = if italicactive(#1 temp2) then deactivateitalic(#1 temp2, #3 temp2,#4 temp2) else (#1 temp2,"", #3 temp2, #4 temp2)
val temp4 = if paragraphactive(#1 temp3) then deactivateparagraph(#1 temp3, #3 temp3,#4 temp3) else (#1 temp3,"", #3 temp3, #4 temp3)
val temp5 = if tableactive(#1 temp4) then tabledeactivate(#1 temp4, #3 temp4, #4 temp4) else (#1 temp4,"", #3 temp4, #4 temp4)
val st= #1 temp5
val s=(1, n , #3 st,#4 st,#5 st, #6 st, #7 st, #8 st)
 in (#1 temp4, #2 temp1 ^ #2 temp2 ^ #2 temp3 ^ #2 temp4 ^ #2 temp5 ^ addquote(n- ( #2 ( #1 temp5)),"") ,l,lout) end
else ((1, #2 state, #3 state, #4 state, #5 state,#6 state, #7 state, #8 state),"",l,lout)
| c :: xs => if c = #">" then indent((0, #2 state, #3 state, #4 state, #5 state, #6 state, #7 state, #8 state),n+1,xs,lout)
else if n > #2 state then let val temp1 = if underlineactive(state)  then deactivateunderline(state, l,lout) else (state,"", l,lout)
val temp2 = if boldactive(#1 temp1) then deactivatebold(#1 temp1, #3 temp1,#4 temp1) else (#1 temp1,"", #3 temp1, #4 temp1)
val temp3 = if italicactive(#1 temp2) then deactivateitalic(#1 temp2, #3 temp2,#4 temp2) else (#1 temp2,"", #3 temp2, #4 temp2)
val temp4 = if paragraphactive(#1 temp3) then deactivateparagraph(#1 temp3, #3 temp3,#4 temp3) else (#1 temp3,"", #3 temp3, #4 temp3)
val temp5 = if tableactive(#1 temp4) then tabledeactivate(#1 temp4, #3 temp4, #4 temp4) else (#1 temp4,"", #3 temp4, #4 temp4) 
val st= #1 temp5
val s=(1, n , #3 st,#4 st,#5 st, #6 st, #7 st, #8 st)
in (s, #2 temp1 ^ #2 temp2 ^ #2 temp3 ^ #2 temp4 ^ #2 temp5 ^ addquote(n- ( #2 ( #1 temp5)),"") ,l,lout) end
else ((1, #2 state, #3 state, #4 state, #5 state,#6 state, #7 state, #8 state),"",l,lout);
fun activateindentation(state : int*int*int*int*int*char*char*char,l : char list, lout : string list) =indent((0, #2 state , #3 state, #4 state,  #5 state, #6 state, #7 state, #8 state),1,l,lout);
fun findlinktype2(l,s)= if l=[] then (s^"Error2",l) else if hd(l)= #"\n" then (s^"Error2",l) else if hd(l)= #">" then (s,tl(l)) else findlinktype2(tl(l),s^Char.toString(hd(l)));
fun activatelinktype2(state : int*int*int*int*int*char*char*char,l : char list, lout : string list)= let val temp=findlinktype2(l,"") in (state,"<a href=\"" ^ #1 temp ^ "\">" ^ #1 temp ^ "</a>", #2 temp,lout) end;
fun errorcheck(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = if #1 state <>1 then if linkactive(state) then let val temp=linkdeactivate(state,"",l,lout) in (#1 temp, "ERROR2"^ #2 temp,#3 temp ,#4 temp) end
 else (state,"ERROR1", l,lout) else (state,"", l,lout);
fun checkfortab(l)= if l=[] then false else if hd(l) <> #" " then false else if tl(l)=[] then false else if hd(tl(l))<> #" " then false else if tl(tl(l))=[] then false else if hd(tl(tl(l))) <> #" " then false else if tl(tl(tl(l)))=[] then false else if hd(tl(tl(tl(l))))<> #" " then false else true;
fun reset(state : int*int*int*int*int*char*char*char, str, l, lout : string list) = let val temp=if headingactive(state) then deactivateheading(state,l,lout) else (state,"",l,lout) in(#1 temp,str^ #2 temp ^ "\n", #3 temp,#4 temp) end;
fun completereset(state : int*int*int*int*int*char*char*char, str, l, lout : string list) = let 
val temp1 = if underlineactive(state)  then deactivateunderline(state, l,lout) else (state,"", l,lout)
val temp2 = if boldactive(#1 temp1) then deactivatebold(#1 temp1, #3 temp1,#4 temp1) else (#1 temp1,"", #3 temp1, #4 temp1)
val temp3 = if italicactive(#1 temp2) then deactivateitalic(#1 temp2, #3 temp2,#4 temp2) else (#1 temp2,"", #3 temp2, #4 temp2)
val temp4 = if tableactive(#1 temp3) then tabledeactivate(#1 temp3, #3 temp3,#4 temp3) else (#1 temp3,"", #3 temp3, #4 temp3)
val temp5 = if paragraphactive(#1 temp4) then deactivateparagraph(#1 temp4, #3 temp4, #4 temp4) else (#1 temp4,"", #3 temp4, #4 temp4)
val temp6 = if listactive(#1 temp5) then endpreviouslist(#1 temp5, #3 temp5, #4 temp5) else (#1 temp5,"", #3 temp5, #4 temp5)
val temp7 = if headingactive(#1 temp6) then deactivateheading(#1 temp6, #3 temp6,#4 temp6) else (#1 temp6,"", #3 temp6, #4 temp6)
val temp8 = if indentation(#1 temp7) > 0 then deacactivateindentation(#1 temp7, #3 temp7, #4 temp7) else (#1 temp7,"",#3 temp7, #4 temp7)
 in (#1 temp8, str ^ #2 temp1 ^ #2 temp2 ^ #2 temp3 ^ #2 temp4 ^ #2 temp5 ^ #2 temp6 ^ #2 temp7 ^ #2 temp8 ^ "\n", #3 temp8, #4 temp8 ) end;
fun matchpattern(state : int*int*int*int*int*char*char*char, l : char list, lout : string list) = 
if #8 state= #"\n" andalso checkfortab(l) andalso listactive(state) andalso checkdigit(#8 state) andalso checklist(l) then addorderedlist(state,sepratelist(l),lout)
else if #8 state= #"\n" andalso checkfortab(l) andalso listactive(state) andalso #8 state= #"-" andalso l<>[] andalso hd(l)= #"-" andalso (tl(l)=[] orelse hd(tl(l))<> #"-") then addunorderedlist(state,tl(tl(l)),lout)
else if #8 state= #"\n" andalso checkfortab(l) andalso ignoring(state)=false then activatecodeblock(state,l,lout)
else if #8 state= #"\n" andalso ignoring(state) andalso checkfortab(l)=false then deactivatecodeblock(state,l,lout)
else if ignoring(state) then (state,Char.toString(#8 state),l,lout)
else if #8 state = #"\n" andalso tableactive(state) = false andalso paragraphactive(state)= false andalso listactive(state)=false then  reset(errorcheck(state, l,lout)) 
else if #7 state= #"\n" andalso #8 state= #"\n" andalso listactive(state)=false then completereset(errorcheck(state, l,lout))
else if #6 state= #"\n" andalso #7 state= #"\n" andalso #8 state= #"\n" then completereset(errorcheck(state, l,lout))
else if listactive(state) andalso #7 state= #"\n" andalso ((checkdigit(#8 state) andalso checklist(l)) orelse ( #8 state= #"-" andalso l<>[] andalso hd(l)= #"-" andalso (tl(l)=[] orelse hd(tl(l))<> #"-"))) then (state,"<li>",l,lout)
else if listactive(state) andalso #7 state= #"\n" andalso #8 state= #"\n" then (state,"</li>\n",l,lout)
else if listactive(state)=false andalso checkdigit(#8 state) andalso #7 state = #"\n" andalso checklist(l) then let val temp1=activatelist(state,l,lout) in addorderedlist(#1 temp1,sepratelist(#3 temp1),#4 temp1) end
else if listactive(state)=false andalso #7 state= #"\n" andalso #8 state= #"-" andalso l<>[] andalso hd(l)= #"-" andalso (tl(l)=[] orelse hd(tl(l))<> #"-") then let val temp1=activatelist(state,l,lout) in addunorderedlist(#1 temp1,tl(tl(#3 temp1)),#4 temp1) end
else if #7 state= #"\n" andalso #8 state = #"#" then let val temp1= completereset(errorcheck(state,l,lout)) val temp2=increaseheadinglevel(#1 temp1,#3 temp1,#4 temp1) in (#1 temp2, #2 temp1 ^ #2 temp2, #3 temp2, #4 temp2) end
else if deciding(state) andalso headingactive(state) andalso #8 state = #"#" then increaseheadinglevel(state, l,lout)
else if deciding(state) andalso headingactive(state) andalso #7 state = #"#" then 
let val temp1=addheading(state,l,lout)  val temp3=matchpattern(#1 temp1, #3 temp1,#4 temp1) in (#1 temp3, #2 temp1 ^ #2temp3, #3 temp3, #4 temp3) end
else if headingactive(state) andalso reading(state) then (state, String.str (#8 state),l,lout)
else if #7 state= #"\n" andalso #8 state = #">" andalso tableactive(state)= false andalso indentation(state)=0 then let val temp1= completereset(errorcheck(state,l,lout)) val temp2=activateindentation(#1 temp1,#3 temp1,#4 temp1) in (#1 temp2, #2 temp1 ^ #2 temp2, #3 temp2, #4 temp2) end
else if indentation(state)>0 andalso #7 state = #"\n" andalso #8 state <> #">" then completereset(errorcheck((#1 state, #2 state, #3 state, #4 state, #5 state , #"\n", #6 state, #7 state),#8 state :: l,lout))
else if indentation(state)>0 andalso #8 state = #">" then activateindentation(state,l,lout)
else if (paragraphactive(state) orelse headingactive(state)) andalso reading(state) andalso #8 state= #"*" then ((0, #2 state, #3 state, #4 state, #5 state , #6 state, #7 state, #8 state) ,"",l,lout)
else if (paragraphactive(state) orelse headingactive(state)) andalso deciding(state) andalso #7 state= #"*" then
if #8 state= #"*" then if boldactive(state) then deactivatebold(state,l,lout) else activatebold(state,l,lout)
else if italicactive(state) then deactivateitalic((#1 state, #2 state, #3 state, #4 state, #5 state, #"\n", #6 state, #7 state),#8 state :: l, lout)
else activateitalic((#1 state, #2 state, #3 state, #4 state, #5 state, #"\n", #6 state, #7 state),#8 state :: l, lout)
else if underlineactive(state) andalso #8 state = #"_" then if l=[] then deactivateunderline(state,l,lout) else if hd(l)= #" " orelse hd(l)= #"\n" then deactivateunderline(state,l,lout) else (state," ",l,lout)
else if underlineactive(state) andalso #8 state = #" " then deactivateunderline((#1 state, #2 state, #3 state, #4 state, #5 state, #"\n", #6 state, #7 state), #8 state :: l,lout)
else if (paragraphactive(state) orelse headingactive(state)) andalso reading(state) andalso underlineactive(state)=false andalso #8 state = #"_"  then activateunderline(state,l,lout)
else if paragraphactive(state)=false andalso #8 state= #"-" then if l=[] then (state,"Error3",l,lout) else if hd(l)<> #"-" then (state,"Error3",l,lout) else if tl(l)=[] then (state,"Error3",l,lout) else if hd(tl(l))<> #"-" then (state,"Error3",l,lout) else ((state,"<hr>",tl(tl(l)),lout))
else if paragraphactive(state) andalso #8 state= #"-" then if l=[] then (state,"Error3",l,lout) else if hd(l)<> #"-" then (state,"Error3",l,lout) else if tl(l)=[] then (state,"Error3",l,lout) else if hd(tl(l))<> #"-" then (state,"Error3",l,lout) else let val temp=deactivateparagraph(state,tl(tl(l)),lout) in (#1 temp,#2 temp ^ "<hr>", #3 temp,#4 temp) end
else if paragraphactive(state) andalso tableactive(state)=false andalso #8 state= #"<" andalso l<>[] andalso hd(l)= #"<" then activatetable(state,tl(l),lout)
else if paragraphactive(state) andalso #8 state= #"<" andalso l<>[] then if hd(l)<> #"h" then (state,Char.toString(#8 state),l,lout) else  if tl(l) = [] then (state,"Error2",l,lout) else if hd(tl(l))<> #"t" then (state,Char.toString(#8 state),l,lout) else if tl(tl(l))=[] then (state,"Error2",l,lout) else if hd(tl(tl(l)))<> #"t" then (state,Char.toString(#8 state),l,lout) else if tl(tl(tl(l)))=[] then (state,"Error2",l,lout) else if hd(tl(tl(tl(l)))) <> #"p" then (state,Char.toString(#8 state),l,lout) else activatelinktype2(state,l,lout)
else if tableactive(state) andalso #8 state= #"\n" then (state,"</TD></TR>\n",l,lout)
else if tableactive(state) andalso #8 state= #"|" then (state,"</TD><TD>",l,lout)
else if tableactive(state) andalso #8 state= #">" then if l=[] then (state,"Error6",l,lout) else if hd(l)<> #">" then (state,"Error6",l,lout) else let val s=if #7 state<> #"\n" then "</TD></TR>" else ""  val temp=tabledeactivate(state,tl(l),lout) in (#1 temp,s ^ #2 temp, #3 temp, #4 temp) end
else if paragraphactive(state) andalso #8 state= #"[" then activatelink(state,l,lout)
else if paragraphactive(state)= false then activateparagraph(state,l,lout)
else (state,Char.toString(#8 state),l,lout);
fun append( state : int*int*int*int*int*char*char*char, sentence,lin : char list, lout : string list) = (state,lin, sentence :: lout);
fun parse( state : int*int*int*int*int*char*char*char, l : char list , lout : string list) = case l of 
 [] => append(matchpattern((#1 state, #2 state, #3 state, #4 state, #5 state, #"\n", #"\n" , #"\n" ),l, lout))  
| c :: xs => parse(append(matchpattern((#1 state, #2 state, #3 state, #4 state, #5 state, #7 state, #8 state, c),xs, lout)));
fun mdt2html(s : string)= let
val input = TextIO.openIn s
val l= explode(TextIO.inputAll input)
fun main() = parse((1,0,0,0,0, #"\n", #"\n", #"\n"),l,[""])
fun write(lout) =let val output = TextIO.openOut "output1.html"
        fun writestrings [] = TextIO.closeOut output
          | writestrings (x::xs) = (TextIO.output (output, x ); writestrings xs) in writestrings(lout) end
fun reverse(state : int*int*int*int*int*char*char*char, l : char list , lout : string list) = rev(lout)
val _=write(reverse(main()))
val _ = TextIO.closeIn input
val input1= TextIO.openIn "output1.html"
val output= TextIO.openOut "output.html"
fun change(l , s ) = if length(l)=1 then s^"\n" else if ord(hd(l))=92 andalso hd(tl(l))= #"n" then change(tl(tl(l)),s) else change(tl(l),s^Char.toString(hd(l)))
fun convert()= if TextIO.endOfStream( input1) then TextIO.output( output,"\n") else let val s= valOf(TextIO.inputLine(input1)) val _=TextIO.output(output,change(explode(s),"")) in convert() end
val _=convert()
val _= TextIO.closeIn input1
val _= TextIO.closeOut output in "DONE" end;