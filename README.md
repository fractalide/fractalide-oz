Who is this for?
--------
If you're the kind of person that likes total control over every aspect of your environment then Fractalide's AGPL v3-or-later codebase allows this freedom for everyone. We use Mozart Oz to implement Flow Based Programming components, these in turn implement Hypercard. Thus by swapping out Hypertalk for a Flow Based Programming Language we allow for maximum modularity, configurability and simplicity. Finally we're aiming to share all components over a Content Centric Network. If you resonate with this mindset of freedom please join the Fractalide community and help create a set of components that'll rival Wolfram Language's stdlib.

Why?
-----
When TCP/IP was invented a printer cost as much as a house and content was on punch cards in your pocket. The Internet was designed to connect computers together to share resources. It wasn't designed for today's usage, namely disseminating exabytes of content across wires. We're currently disseminating content over a point-to-point network. Leslie Lamport showed this process is quadratic time best case, exponential time worst case scenario. Content Centric Networking, the brain child of Van Jacobson etal is a good solution to this problem. In other words, the problem has shifted away from connecting computers to cheaply disseminating data far and wide. We shouldn't have to rely on billion dollar companies to disseminate our data. Content Centric Networking builds data dissemination and search into the networking protocol. So it makes sense for a new browser specifically engineered for Content Centric Networking be created.


Fractalide
-------
Textual code isn't very approachable to the average non-programmer. We feel the combination of Hypercard with a Flow Based Programming (FBP) language is a much better approach to programming. By using [Mozart Oz](www.mozart-oz.org) to implement FBP we deliver some 30 odd factored language concepts to FBP component developers. A few of those concepts allows for the Declarative Concurrent paradigm which enables the simple creation of open Internet applications.
We aim to make the process of creating and sharing applications so simple you can do it on your tablet with just your finger.

Fractalide means Fractal Integrating Development Environment. We take a leaf of Rob Pike's ACME text editor by making the implementation integrate well with your existing environment, by using tools such as a pdf reader, favourite text editor or GNU's unix commands.

Usage
-----

* You'll need to setup the latest version of [mozart](www.github.com/mozart/mozart2) (as we found a bug in Mozart2 stdlib that prevented correct rendering of the Canvas element, so the Sourceforge binary won't work)
* Setup Oz's environmental variables; point `OZHOME` to the root folder and put the `bin` folder on `PATH`
* `git clone git://github.com/fractalide/fractalide.git`
* `cd fractalide`
* `make && make editor`
* `$ ./fractalide.sh`
* `ozengine launcher.ozf testCanvas.fbp`
* `ozengine launcher.ozf testWidget.fbp`
* `ozengine launcher.ozf test.fbp`
* `ozengine launcher.ozf testDnD.ozf`

License
--------
All code is AGPL v3-or-later.
All content published on this platform is licensed as Creative Commons. 
This is not a commercial dual license project. You own your contributions. 
If you want privacy, encrypt your content. (This will eventually be automatic)
