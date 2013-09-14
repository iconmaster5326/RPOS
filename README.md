RPOS
====

RPOS is a unique shell/programming language made by iconmaster. It stands for Reverse Polish Operating System (or alternately, Reverse POlish Shell). It is a combination of RPL and DOS, as it has both a filesystem and a stack.

RPOS takes a space-separated string of words. Each word can be either a number, a string (with ' or " prefixes), or a command. Numbers and strings are pushed onto the stack, commands are executed. Alternately, words can have a one-character symbol prefix; these prefixes change how the characters after are used. There are 3 basic data types: Numbers, strings, and directories. Numbers and strings may be pushed onto the stack; directories may not. Directories contain an associative array of data; the key is the variable's name, the value is that variable's value. The root directory and the starting current directory is called root. The system starts up with a directory inside root called sys. This contains system variables.

To start using RPOS, I suggest using the 'help' command.

Changelog
=========

Version 2.3.1
* Fixed bug in writing files in the Windows platform.
* Added platform files for ComputerCraft and Unix-based platforms.
* Added system variable 'termchr', which represents the character which will terminate the prompt of the write command.

Version 2.3.0
* Added platform files. These files, stored in RposData as .rplt files, are writen in Lua and (re)define functions for system I/O. It loads the platform called platform.rplt in the same directory as rpos.lua.
* Made some external file system commands give errors when the file isn't found.
* Fixed some typos.

Changes before v2.2 are unkwown.
