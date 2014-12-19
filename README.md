BackNode
========

The Online HTML Editor. A back office for your users to edit your HTML pages. You can find more infos on http://www.backnode.io/

###Contribute
We're using Waffle.IO to manage issues as part of an Agile/SCRUM process. Feel free to add new ideas to our [Backlog](https://waffle.io/silexlabs/BackNode)
Please use the `.editorconfig` file to develop so the code will stay clean.

###Installation of the online tool

####Requirements

* [node.js](http://nodejs.org/) installed
* [NPM](https://www.npmjs.com/) installed
* [gulp](http://gulpjs.com/) installed
* [jade](http://jade-lang.com/) installed

```shell
$ npm install
$ bower install
$ gulp && node unifile-server.js
```

###Contribute

```shell
$ gulp
$ node unifile-server.js
```
Then open a browser at [http://0.0.0.0:6969](http://0.0.0.0:6969)

To get a live reload, just use gulp command
```shell
$ gulp watch
```

###Philosophy

BackNode allows non-technician people to easily manage the content of their website.

Backnode helps you to edit the images and texts of your website in a simple and efficient way. You do not need to learn to code, you just have to open Backnode and you're done !

And it goes along with other free tools:
* [Silex](http://www.silex.me/): Edit design
* [Responsize](http://www.responsize.org/): Handle responsiveness
