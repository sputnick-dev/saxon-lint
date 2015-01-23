xquery version "3.0";

(: Test to see if a word is in a list :)
(: from https://en.wikibooks.org/wiki/XQuery/Filtering_Words :)
declare namespace exist = "http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes omit-xml-declaration=yes";

(: A list of words :)
let $stopwords :=
<words>
   <word>a</word>
   <word>and</word>
   <word>in</word>
   <word>the</word>
   <word>or</word>
   <word>over</word>
</words>

let $input-text := 'a quick brown fox jumps over the lazy dog'
return
<html>
   <head>
      <title>Test of is a word on a list</title>
     </head>
   <body>
   <h1> Test of is a word on a list</h1>
   
   <h2>WordList</h2>
   <table border="1">
     <thead>
       <tr>
         <th>StopWord</th>   
       </tr>
     </thead>
     <tbody>{
     for $word in $stopwords/word
     return
        <tr>       
           <td align="center">{$word}</td>              
        </tr>
     }</tbody>
   </table>
   
   <h2>Sample Input Text</h2>
   <p>Input Text: <div style="border:1px solid black">{$input-text}</div></p>
   <table border="1">
     <thead>
       <tr>
         <th>Word</th>
         <th>On List</th>       
       </tr>
     </thead>
     <tbody>{
     for $word in tokenize($input-text, "\s+")
     return
     <tr>       
        <td>{$word}</td>      
        <td>{
          if ($stopwords/word = $word)
            then(<font color="green">true</font>)
            else(<font color="red">false</font>)
        }</td>
     </tr>
     }</tbody>
   </table>
  </body>
</html>
