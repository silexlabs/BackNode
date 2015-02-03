BackNode
========

The Online HTML Editor. A back office for your users to edit your HTML pages. You can find more infos on http://www.backnode.io/

###Contribute
We're using Waffle.IO to manage issues as part of an Agile/SCRUM process. Feel free to add new ideas to our [Backlog](https://waffle.io/silexlabs/BackNode)
Please use the `.editorconfig` file to develop so the code will stay clean.

###Installation of the online tool

####Requirements

This git repository is using [submodules](http://www.git-scm.com/book/en/v2/Git-Tools-Submodules). Be sure to get them to by cloning with the recursive option: `git clone --recursive https://github.com/silexlabs/BackNode.git`.

* [node.js](http://nodejs.org/) installed
* [NPM](https://www.npmjs.com/) installed
* [Haxe](http://haxe.org/download/) installed
* [Bower](http://bower.io/#install-bower) installed
* [Jade](http://jade-lang.com/command-line/) installed
* [Sass](http://sass-lang.com/install) installed
* [RSYNC](http://www.rsync.net/resources/howto/windows_rsync.html) (windows only)

```shell
$ npm install
$ bower install
$ npm start && node unifile-server.js
```

###Contribute

```shell
$ npm start
$ node unifile-server.js
```
Then open a browser at [http://localhost:6969](http://localhost:6969)

To get an automatic build when some modification append, just use npm command
```shell
$ npm run watch
```

###Philosophy

BackNode allows non-technician people to easily manage the content of their website.

Backnode helps you to edit the images and texts of your website in a simple and efficient way. You do not need to learn to code, you just have to open Backnode and you're done !

And it goes along with other free tools:
* [Silex](http://www.silex.me/): Edit design
* [Responsize](http://www.responsize.org/): Handle responsiveness
