---
date: 2024-08-24
categories: 
  - Hardware
authors:
  - petrilli 
---
# Development Boards to Go

I have a somewhat long trip coming up, and I won't be taking my workshop
with me. Still, I want to be able to work on this project while I'm
traveling. The decision I came to was to build a couple of development
boards that are generic versions that I can use while I travel. I can
slot these into the backplane, and pack just a single 12V power supply.

## Goals

The project consists of two kinds of things: boards that slot into the
chassis and contain some amount of UI, and endpoints that affect the
world around them. I'm pretty sure I can build a single board and get
most of what I need from that via some I~2~C magic. The hope is that
this lets me have enough to work on _most_ things while I'm away from
home without having to carry a lot of extra things with me.

## Universal Card

The card needs some basic components: 

- DIN 41612 backplane connector to get power and send CAN-FD signals.
- WeAct STM32G474 Long MCU module
- Some status LEDs for LED.

I'm planning to have the following I/O on the board:

- 2 [Nidec TM push
  buttons](https://www.nidec-components.com/us/product/detail/00000326/) 
  with built-in LED.
- 2 [PB86-A2 push
  buttons](https://www.aliexpress.us/item/2251832782113850.html) with
  both red and green LEDs.
- 1 [Alps EC11 rotary
  encoder](https://tech.alpsalpine.com/e/products/category/encorders/sub/01/series/ec11e/).
- 1 small toggle switche.
- 1 [Alps Alpine slide
  potentiometer](https://www.mouser.com/c/passive-components/potentiometers-trimmers-rheostats/slide-potentiometers/?m=Alps%20Alpine).
- 3 red LED switched by a MOSFET.
- 3 green LED switched by MOSFET.
- 4 [WS2812B](http://world-semi.com/ws2812-family/) RGB LED.
- 4 digit 7-segment display, driven by a
  [MAX7219](https://www.analog.com/en/products/MAX7219.html).
- 1 3.3V I/O for driving a relay board. This will come out on a JST PH
  connector. See below.
- General I~2~C bus on an JST PH (SH?) compatible with [Adafruit
  STEMMA](https://learn.adafruit.com/introducing-adafruit-stemma-qt/what-is-stemma).
- CAN-FD using a [TCAN1057]() tranceiver and [ESD2CANFD]() ESD
  protection on the backplane and JST PH connector. The connector can be
  used for termination.

For 1 each of the buttons, I'll use a physical debounce (discussed
below). For the other, I'll do it in software. Let's see how that plays
out. 

In addition, because the card is fed with 5V from the backplane, we'll
need a 3.3V LDO regulator, probably a 1117-style in fixed output.


### Relay Card

The relay card is going to be a bit more "interesting" in a lot of
ways. Because I want to be able to (potentially) handle mains voltage
(110-120VAC in the US), I have to be careful and take quite a few
precautions.

The board will have an AC relay ([Omron G2RL-1A-E-ASI
DC5](https://components.omron.com/us-en/products/relays/G2RL)) driven
via a [DRDC3105F](https://www.diodes.com/part/view/DRDC3105F/).


## Physical Debounce

While it's possible to do debounce in software, and quite common today
to do that with the surfeit of CPU cycles most people have available, I
feel like seeing what it would be like to use a physical debounce
circuit. First, what the heck is switch bouncing and why do you need to
debounce it? I'm gonna borrow some diagrams from [this
article](https://www.digikey.com/en/articles/how-to-implement-hardware-debounce-for-switches-and-relays)
to tell the story. 

First, let's take a look at what it looks like without debouncing on a
normal SPST switch:

![Image showing both a switch with a pull-up resistor, and the behavior
of it with both clean and dirty bounces](img/debounce-no-circuit.jpg)

You can see how, due to the mechanical nature of the switch, there can
be some bouncing of the output, even with a pull-up resistor. Now, let's
take a look at it when you add an RC circuit:

![Switch shown with an RC circuit on the output, and charts showing the
discharge and charge cycle](img/debounce-rc-circuit.jpg)

Here we use an RC circuit where the resistor controls the charge and
discharge of the capacitor, and a [Schmitt
trigger](https://en.wikipedia.org/wiki/Schmitt_trigger) to ensure that
we get a clean transition. The general guidance is that 20ms is plenty
of time for the switch to settle, so if we aim for a 20ms time constant
(&tau;) on the RC circuit, we get:

$$\begin{align}
\tau & = R\times C \\
     & = 100K \times 220nF \\
     & = 0.022 
\end{align}$$

Close enough for Seattle.

For the Schmitt trigger, I'm just going to use a
[74LVC1G14](https://octopart.com/search?q=74LVC1G14&currency=USD&specs=0)
which are available in a small SOT package.

For the SPDT switch, however, I want to use an alternate strategy based
on NAND gates in an SR latch configuration. The Cadillac of debounce, as
it were. 

![Debounce circuit showing an SPDT switch connected to a dual NAND
gate](img/debounce-nand-circuit.jpg)

For the NAND gate, I'm going to use the basic
[74HC00](https://octopart.com/search?q=74HC00&currency=USD&specs=0),
which unfortunately in the form I have is in an SOIC-14 package. But I
paid less than $0.09 each, so who is complaining?