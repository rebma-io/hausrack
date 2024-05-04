---
date: 2024-05-03
categories: 
  - Hardware
authors:
  - petrilli 
---
# CAN on 8p8c Connectors

!!! info inline end "8p8c is not RJ45"
      *Pedantic Warning* You will often hear people call the modular
      connectors that are used for Ethernet "RJ45", but that standard is
      a very specific thing that is not actually what you're using. The
      correct term is an 8p8c connector, which refers to the 8 positions
      and 8 contacts. 

      I have often done this myself, but for the purposes of being 
      [technically correct](https://www.youtube.com/watch?v=hou0lU8WMgo), 
      I will try my best to stick to the proper designation.

For the project, I want to connect the string of devices over CANbus. To
do that, I intend to leverage the ubiquitous
[8p8c](https://en.wikipedia.org/wiki/Modular_connector#8P8C) that you
see all over the place in Ethernet.

## Goals

There were a few goals in mind:

1. Use existing standards and easily available connectors and cables
2. Deliver power over the same cable as the signal
3. Provide reasonable noise immunity

The noise immunity is pretty easy given this is a differential signal
and we are going to use twisted pairs to twist the high and low signal
together. Looking at an oscilloscope trace of the CAN signal from [this
TI application note](https://www.ti.com/lit/an/sloa101b/sloa101b.pdf),
you can see the differential nature:

![An oscilloscope plot showing a single-ended signal converted to
differential signal](img/ti-sloa101b-can-bus.png)


## Connector Signal Mapping

For the ends, I chose to use a rather boring layout, but I wanted to
make sure CAN was twisted together, and that each of the +12V wires was
also twisted with a ground.

```wireviz
connectors:
    X1:
        pincount: 8
        type: 8p8c
        subtype: plug
        pinlabels: [
            CAN_H,
            CAN_L,
            GND,
            +12V,
            +12V,
            GND,
            GND, 
            +12V
        ]
```


## Cable Wiring

The wiring is standard Ethernet wiring, following the
[T568A](https://www.flukenetworks.com/knowledge-base/application-or-standards-articles-copper/differences-between-wiring-codes-t568a-vs)
standard. The reality is that it doesn't matter whether you use T568A or
T568B, quite honestly, but I just picked A because it's the most common
and what the typical patch cable is wired for.

[Category 5/5e](https://en.wikipedia.org/wiki/Category_5_cable) is more
than adequate for the signalling that CAN or CAN FD use. The general
rating for Category 5 is 100MHz, and if we look at a quality cable, like
the [Belden
1224](https://www.belden.com/products/cable/ethernet-cable/category-5e-cable/1224),
we can see that it has the following characteristics:

| Max DCR    | Max DCR Imbalance | Max Capacitance | Insertion Loss(100MHz) | Fitted Impedence   |
| ---------- | ----------------- | --------------- | ---------------------- | ------------------ |
| 89&ohm;/km | 3%                | 33pF/100m       | 21dB/100m              | 100&plusmn;15&ohm; |

And it is, in fact, rated to 350MHz, far in excess of what's needed.

The makes the overall wiring looks like this:

```wireviz
connectors:
    X1:
        pincount: 8
        type: 8p8c
        subtype: plug
        pinlabels: [
            CAN_H,
            CAN_L,
            GND,
            +12V,
            +12V,
            GND,
            GND, 
            +12V
        ]
    X2:
        pincount: 8
        type: 8p8c
        subtype: plug
        pinlabels: [
            CAN_H,
            CAN_L,
            GND,
            +12V,
            +12V,
            GND,
            GND, 
            +12V
        ]
cables:
    W1:
        wirecount: 8
        type: cat5e
        gauge: 24 AWG
        show_equiv: true
        color_code: T568A
connections:
    -
        - X1: [1-8]
        - W1: [1-8]
        - X2: [1-8]
```

# Power Handling

!!! info inline end "Voltage Smoltage"
    I haven't actually settled on the voltage to use on the cabling. For
    now, I am using +12V, but moving up to +48V would (basically)
    quadruple the available power without requiring any additional
    copper. It does, however, somewhat complicate the individual device
    power supplies.

At this point, I'm planning to run +12V across the cable to allow for
most things to be powered off the central device. Given I use solid
rather than stranded cables, we can the [standard AWG wire
gauge](https://www.engineeringtoolbox.com/wire-gauges-d_419.html)
ratings of 3.5A on a 24 AWG single-core wire.

Now we can't do the math quite yet, as we need to
[derate](https://en.wikipedia.org/wiki/Derating) the wire based on two
different factors, according to the
[NEC](https://en.wikipedia.org/wiki/National_Electrical_Code):

1. Ambient operating temperature
2. More than 3 wires in a cable

So, if we do the math for operating at 40C (104F), and with the 3 power
carrying conductors in the cable, we get derating factors of 0.88 and
0.80 respectively. So...

$$\begin{align}
P &= 3 (3.5A \times 0.88 \times 0.80) \\
  &= 3 (2.464) \\
  &= 7.392A
\end{align}
$$

So that means we can do 7.392 * 12 = 88.7W of power on the cable. _But
there's a catch_. The current most advanced power-over-ethernet (PoE)
standard, IEEE 802.3bt-2018, says that each _pair of conductors_ is
designed to handle 960mA, which would actually put us at (generously!)
960 &times; 2 or 1.92A, or 23W at 12V.

This is the reason I'm thinking of switching to driving the cable with
48V, which would let me move up to 92W, which is about what the standard
allows. So, perhaps I will change to a 48V distribution, which will
require something like an [LM5576](https://www.ti.com/product/LM5576). 

We'll burn that bridge when we come to it.


## Quick Note About Diagrams

The diagrams above were done with an amazing tool called
[Wireviz](https://github.com/wireviz/WireViz/), and embedded into the
MkDocs site you're reading using a little hacky [Markdown extension I
wrote](https://github.com/petrilli/wireviz_fences). 