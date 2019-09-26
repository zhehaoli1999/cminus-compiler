# Lab1 report 
杨舒静 PB17151774

## Implementation
1. Regular expression
    ```cpp
    letter 		[a-zA-Z]
    digit		[0-9]
    identifier	{letter}{letter}*
    number		{digit}{digit}* 

    %%	
        
    {number}		{return NUMBER;}
    int				{return INT;}
    if			 	{return IF;}
    void			{return VOID;}
    while			{return WHILE;}
    return			{return RETURN;}
    else			{return ELSE;}
    [\t]			{return BLANK;}
    "{"				{return LBRACE;}
    "}"				{return RBRACE;}
    "("				{return LPARENTHESE;}
    ")"				{return RPARENTHESE;}
    "["				{return LBRACKET;}
    "]"				{return RBRACKET;}
    "+"				{return ADD;}
    "-"				{return SUB;}
    "*"				{return MUL;}
    "/"				{return DIV;}
    ">="			{return GTE;}
    "<="			{return LTE;}
    "=="			{return EQ;}
    ">"				{return GT;}
    "<"				{return LT;}
    ","				{return COMMA;}
    " "				{return BLANK;}
    \/\*			{return COMMENT;}
    \n				{return NEWLINE;}
    \*\/			{return UNCOMMENT;}
    ";"				{return SEMICOLON;}
    "!="			{return NEQ;}
    "="				{return ASSIN;}
    {identifier}\[{number}*\]+ {return ARRAY;}
    {identifier} 	{return IDENTIFIER;} 


    . 				{return ERROR;}
    ```

## Testing

Besides testcase in the `testcase\`, I consider additional cases as follow.

1. Multiple line comments
```cpp
/*
comments
comments
comments
*/

/*comment1*/
statement
/*comment2*/

/*comments*/statement
```

In the program, I utilize a variable `flag` in the `analyzer` function to denote whether the analyzer is reading comments. When it first meets `\*`, the flag will be set to `true`. When it meets the end `*/`, the flag will be set to `false`.

There might be other solutions which better utlize `flex` properties, such as [answers](https://stackoverflow.com/questions/20879643/error-unrecognized-rule-in-flex-tool/20885305) in stackoverflow
2. Arrary  
There has been multiple forms of arrays, i.e. `A[number]`, `A[]`


## Debugging

In the following section, series of bugs and the corresponding solutions will be listed.

1. How to cope with multiple lines comments ?

2. `Segematation Fault(core dump)`
   1. It has nothing to do with `DIV` pointer.
   2. Whether files have been open properly should be checked
3. Wrong file name
   1. I pass the input file name(with suffix) to the `analyzer` and found that when testcase folder includes 3 testcases, it will produce wrong file names
   2. The solution is to initialize the `name` variable
4. Notes about flex grammar
   1. The declaration of syntax i.e. `letter` should be above `%%`
   2. According to the [document](http://dinosaur.compilertools.net/flex/manpage.html) of Flex, how the input is matched has nothing to do with the sequence that regular expressions are programmed in. It depends on the max length that the regular expression can be matched with.
   
        >When  the  generated scanner is run, it analyzes its input
            looking for strings which match any of its  patterns.   If
            it  finds  more	than one match, it takes the one matching
            the most text (for trailing context rules,  this	 includes
            the  length of the trailing part, even though it will then
            be returned to the  input).   If	 it  finds  two	 or  more
            matches	of  the same length, the rule listed first in the
            flex input file is chosen.


## Schedule

item | time
-----|-----
Linux(VMware) | 30min
programming | 1h30min 
debugging | 1h30min
