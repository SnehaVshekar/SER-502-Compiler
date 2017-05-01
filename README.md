# SER502-Spring2017-Team23

Compiler and Virtual Machine for a Programming Language - Orange on Windows


Flex is used a Lexer. Bison is used as a Parser. gcc is used to generate the executable file for the intermediate code. Java used as Runtime


Steps to Generate Intermediate Code: 

•	bison -dy ORJ.y
•	flex ORJ.l
•	gcc -o exe.orj lex.yy.c y.tab.c -lm


Compiling ORJ code

•	exe.orj test.orj


Steps to execute Runtime:

•	javac Runtime.java
•	java Runtime test.orj.int





Link to Github Repository - https://github.com/AbhishekNagaraj/SER502-Spring2017-Team23



Link to youtube video - https://www.youtube.com/watch?v=ZKg5H_-fa0M
