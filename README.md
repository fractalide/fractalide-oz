Fractallang
===========

Fractal-lang is an implementation of flow based programming language using Mozart Oz (www.mozart-oz.org)

It is the front end language for fractalide a content centric network browser.

In other words, what Javascript is to a Channel Centric Browser (HTTP Browser), so Fractal-lang is to a Content Centric Browser.

Why?
-----
The Internet was designed to connect computers together, it wasn't designed for today's usage, namely delivering exabytes of data across the wires. Content Centric Networking, the brain child of Van Jacobson etal is a good solution to this problem. The problem has shifted away from connecting computers to disseminating data far and wide cheaply. We shouldn't have to rely on billion dollar companies to disseminate our data. Content Centric Networking builds data dissemination and search into the networking protocol. So it makes sense for a new browser specifically engineered for content centric networking be created.

Why Fractallang? Why not Javascript?
-------------
Javascript has many flaws, single process, no object oriented support, and a plethora of other issues. Most importantly textual code isn't very approachable to the average non-programmer. We feel that Flow Based Programming (FBP) is a much better approach to programming and by using Mozart-oz to implement FBP we deliver some 30 odd different and factored language concepts to FBP component developer. A few of those concepts allows for the Declarative Concurrent paradigm which enables the simple creation of open Internet applications.

Fractalide?
-------
Fractalide means Fractal Integrating Development Environment. We take a leaf of Rob Pike's ACME text editor by making the implementation integrate well with your existing environment, by using your existing tools such as a pdf reader, or GNU's unix commands.
Fractalide, to be implemented in Rust-lang will have fractallang and the libmozart library included in it, once we're satisfied with fractallang on Mozart2 as a proof of concept.

Usage
-----

* Download [Mozart Oz](http://sourceforge.net/projects/mozart-oz/?source=directory) from Sourceforge.
* Setup Oz's environmental variables; point `OZHOME` to the root folder and put the `bin` folder on `PATH`
* `git clone git://github.com/fractalide/fractallang.git`
* `cd fractallang`
* `make`
* `ozengine testSub.ozf testCanvas.fbp`
* `ozengine testSub.ozf testWidget.fbp`
* `ozengine testSub.ozf test.fbp`
