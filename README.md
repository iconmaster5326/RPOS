RPOS
====

RPOS is an (arguably) esoteric programming language made by iconmaster. It stands for Reverse Polish Operating System (or arternately, Reverse POlish Shell). It is a combination of RPL and DOS, as it has both a filesystem and a stack.

RPOS takes a space-seperated string of words. Each word can be either a number,a string (with ' or " prefixes), or a command. Numbers and strings are pushed onto the stack, commands are executed. Alternately, words can have a one-character symbol prefix; these prefixes change how the characters after are used. There are 3 basic data types: Number, string, and directory. Numbers and strings may be pushed onto the stack; directories may not. Directories contain an associtive array of data; the key is the varname, the value is that var's value. The root directory and the starting current directory is called root. The system starts up with a directory inside root called sys. This contains system variables.

To start using RPOS, I suggest using hte 'help' command.

Changelog
=========

Changes before v2.2 are unkwown.
