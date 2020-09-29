#!/usr/bin/python

import sys

# default values
t="0"
r="0"
m="0"
s="0"
c="0"
x="0"
y="0"
z="0"

# Store the input flags
valflags = str(sys.argv[1])

# loop over input flags
for b in valflags:
	if ((b=='t') or (b=='T')):
		t="1"
	elif ((b=='r') or (b=='R')):
		r="1"
	elif ((b=='m') or (b=='M')):
		m="1"
	elif ((b=='s') or (b=='S')):
		s="1"
	elif ((b=='c') or (b=='C')):
		c="1"
	elif ((b=='x') or (b=='X')):
		x="1"
	elif ((b=='y') or (b=='Y')):
		y="1"
	elif ((b=='z') or (b=='Z')):
		z="1"
	else:
		pass

# build output flags
stringflags=z + y + x + c + s + m + r + t

# convert to int
setflags = int(stringflags, 2)

# Debug
# print ">>> DEBUG:"
# print "valflags = ",valflags
# print "stringflags = ",stringflags
# print "setflags = ",setflags

# write the result to file
with open('flags.txt', 'w') as f:
  f.write('%d' % setflags)
