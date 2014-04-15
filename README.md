Fractallang
===========

Fractallang is an implementation of Hypercard that swaps out Hypertalk for a Flow Based Programming language.

It is the front end language for Fractalide a content centric network browser.

In other words, what Javascript is to a Channel Centric Browser (HTTP Browser), so Fractallang is to a Content Centric Browser.

Why?
-----
When TCP/IP was invented a printer cost as much as a house and content was on punch cards in your pocket. The Internet was designed to connect computers together to share resources. It wasn't designed for today's usage, namely disseminating exabytes of content across wires. We're currently disseminating content over a point-to-point network. Leslie Lamport showed this process is quadratic time best case, exponential time worst case scenario. Content Centric Networking, the brain child of Van Jacobson etal is a good solution to this problem. In other words, problem has shifted away from connecting computers to cheaply disseminating data far and wide. We shouldn't have to rely on billion dollar companies to disseminate our data. Content Centric Networking builds data dissemination and search into the networking protocol. So it makes sense for a new browser specifically engineered for Content Centric Networking be created.

Fractallang
-------------
Textual code isn't very approachable to the average non-programmer. We feel the combination of Hypercard with a Flow Based Programming (FBP) language is a much better approach to programming. By using [Mozart Oz](www.mozart-oz.org) to implement FBP we deliver some 30 odd factored language concepts to FBP component developers. A few of those concepts allows for the Declarative Concurrent paradigm which enables the simple creation of open Internet applications.
We aim to make the process of creating and sharing applications so simple you can do it on your tablet with just your finger.

Fractalide
-------
Fractalide means Fractal Integrating Development Environment. We take a leaf of Rob Pike's ACME text editor by making the implementation integrate well with your existing environment, by using your existing tools such as a pdf reader, favourite text editor or GNU's unix commands. Indeed, Fractalide will also be released in library form, so you can include it into your applications and integrate with a Content Centric Network (obviously you would just use FBP and not Hypercard).
Fractalide, to be implemented in Rust-lang, will have Fractallang and the libmozart library included into it. Though, only once we're satisfied with Fractallang on the Mozart2 Programming Environment as a proof of concept. This is the main standalone executable that includes the Content Centric Networking backend.
Hence Fractalide is an implementation of Hypercard on a Content Centric Network.

Usage
-----

* You'll need to setup the latest version of [mozart](www.github.com/mozart/mozart2) (as we found a bug in Mozart2 stdlib that prevented correct rendering of the Canvas element)
* Setup Oz's environmental variables; point `OZHOME` to the root folder and put the `bin` folder on `PATH`
* `git clone git://github.com/fractalide/fractallang.git`
* `cd fractallang`
* `make`
* `ozengine testSub.ozf testCanvas.fbp`
* `ozengine testSub.ozf testWidget.fbp`
* `ozengine testSub.ozf test.fbp`
* `ozengine testSub.ozf testDnD.ozf`

License
--------
AGPL v3-or-later, all content published on this platform is licensed as Community Commons. This is not a dual commercial licensed project. You own your contributions. If you want your content private, then encrypt it.
