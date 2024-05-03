# HAUSRACK Test Backplane

More details on the
[update](https://hausrack.rebma.io/updates/2024/05/02/a-bus-is-a-bus-of-course-of-course/).

## Design Principles

When I was looking at how [kha](https://github.com/kiu/kha/) structured
the bus, I decided to pull a few ideas from what they did:

1. Leverage DIN 41612 for the physical format of the bus. This is a very
   well understood and documented specification, and it has been
   battle-tested over many decades.
2. Simplify the backplane routing requirement.
3. Carry both +12V and +5V. Can be locally regulated down to the needed
   voltage.

## Physical Connector

I decided to use the DIN 41612 connector because it is an absolute tank.
It has been used, at least, since the late 1980s in dozens and dozens of
critical systems. It's also relatively inexpensive and not very finicky
to work with.