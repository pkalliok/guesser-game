Guesser
=======

This game is explained in:
http://sange.fi/~atehwa/cgi-bin/piki.cgi/experiences%20on%20writing%20a%20toy%20game%20with%20l%F6ve

To run:

```
$ make guesser.love
$ love guesser.love
```

To play:

 * agree with players how many strings each player will write.
 * let everyone write their strings, each followed by "enter".
 * you can also enter common, "neutral" strings, which are there just to
   disturb the system.  Neutral strings can be entered before of after
   the player entries, and can be agreed on with all players, or just
   given subsets of them.
 * When you've typed in all the strings you want, press "enter" twice.

You can see your words twirl around.  In time, the network will
stabilise with different words in constant positions.  The winner is the
word closest to the center (the view is always centered at the average
position of the words).

You can also reseed the system by pressing "enter" once again.  Because
the initial word positions are random, they might find another local
optimum at which their positions stabilise.

