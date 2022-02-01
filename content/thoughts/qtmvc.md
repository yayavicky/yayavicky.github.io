---
title: "MVC Design and PyQT"
date: 2020-01-31T16:19:21+08:00
draft: false
tags: 
    - "Thoughts"
    - "MVC"
    - "PyQT"
categories :                             
    - "MVC"
    - "Thoughts"
    - "PyQT"
keywords :                                 
    - "python"
    - "thoughts"
    - "PyQT"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "MVC Design and PyQT" # Lead text
comments: false # Enable Disqus comments for specific page
authorbox: true # Enable authorbox for specific page
pager: true # Enable pager navigation (prev/next) for specific page
toc: true 
mathjax: false # Enable MathJax for specific page
sidebar: "right" # Enable sidebar (on the right side) per page
widgets: # Enable sidebar widgets in given order per page
  - "search"
  - "recent"
  - "taglist"
---

## 资源

+ [MVC design with Qt Designer and PyQt / PySide](https://stackoverflow.com/questions/26698628/mvc-design-with-qt-designer-and-pyqt-pyside)
+ [Why Qt is misusing model/view terminology?](https://stackoverflow.com/questions/5543198/why-qt-is-misusing-model-view-terminology)
+ [Presentation Model](https://martinfowler.com/eaaDev/PresentationModel.html)
+ [Development of Further Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaDev/index.html)
+ [GUI Architectures](https://martinfowler.com/eaaDev/uiArchs.html)
+ [Development of Further Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaDev/)



## 建议的文件结构

```shell
project/
    mvc_app.py              # main application with App class
    mvc_app_rc.py           # auto-generated resources file (using pyrcc.exe or equivalent)
    controllers/
        main_ctrl.py        # main controller with MainController class
        other_ctrl.py
    model/
        model.py            # model with Model class
    resources/
        mvc_app.qrc         # Qt resources file
        main_view.ui        # Qt designer files
        other_view.ui
        img/
            icon.png
    views/
        main_view.py        # main view with MainView class
        main_view_ui.py     # auto-generated ui file (using pyuic.exe or equivalent)
        other_view.py
        other_view_ui.py
```



## Why Qt is misusing model/view terminology?



I think that the terminology used in Qt with model/view controls is flawed. On [their explanation page](https://doc.qt.io/qt-5.7/model-view-programming.html) they state, that they simplified the MVC to MV by merging View and Controller and they are giving the following picture:



However I think, they misnamed the roles of objects and I think that,

1. What they call View with merged Controller is in fact a View only.
2. What they call Model is in fact Controller only.
3. If you really want to have a model it would be somewhere where their "Data" is.

I am speaking about usual and sane way you would use Qt model/view component in your app. Here are the reasons:

1. This is typically Qt component which is used as is, without adding any Controller logic specific to your objects)
2. This is hardly a Model, just because you should implement several Qt methods like rowCount, columnCount, data etc. which have nothing to do with your model. In fact there are typical model methods found in Controllers. Of course, you can implement both Controller **and** Model logic here, but first it would be quite bad code design and secondly you would merge Controller and Model not Controller and View as they state.
3. As said in reason 2. if you want to separate Model logic that it is surely not the blue box on the picture, but rather the dashed "Data" box (communicating to real Data of course).

Is Qt wrong in their terminology, or it is just me who does not understand? (BTW: The reason why it is not academic question is that I have started to code my project following their naming and I have soon found out, that the code clearly is not right. It was only after that when I realized, that I should not try put Model logic in what they call Model)



 In the [original smalltalk paper](http://st-www.cs.illinois.edu/users/smarch/st-docs/mvc.html) it says:

> The view manages the graphical and/or textual output to the portion of the bitmapped display that is allocated to its application. The controller interprets the mouse and keyboard inputs from the user, commanding the model and/or the view to change as appropriate. Finally, the model manages the behavior and data of the application domain, responds to requests for information about its state (usually from the view), and responds to instructions to change state (usually from the controller).



In light of that I would answer your three main concerns thusly:

1. In fact a Qt component "manages the graphical [...] output", and "interprets the mouse and keyboard inputs", so it could indeed be called merged View and Controller with respect to the definition above.
2. I agree that you are/would be forced to merge Controller and Model (again with respect to the definition above).
3. I agree, again. The Model should only manage the data of the *application domain*. This is what they call "data". Clearly, dealing with rows and columns for example has normally nothing to do with our applications domain.

Where does it leave us? In my opinion, it is best to figure out what Qt really means when the terms "Model" and "View" are used and use the terms in their manner while we are programming with Qt. If you keep being bothered it will only slow you down, and the way things are set up in Qt does allow elegant design - which weighs more that their "wrong" naming conventions.



----------------------------------------

## Short answer

Qt's MVC only applies to **one data structure**. When talking about an MVC **application** you should not think about `QAbstractItemModel` or `QListView`.

If you want an MVC architecture for your whole program, Qt hasn't such a "huge" model/view framework. But for each list / tree of data in your program you can use the Qt MVC approach which indeed has a **controller** within its view. The **data** is within or outside of the model; this depends on what type of model you are using (own model subclass: probably within the model; e.g. QSqlTableModel: outside (but maybe cached within) the model). To put your models and views together, use own classes which then implement the **business logic**.

------

## Long answer

*Qt's model/view approach and terminology:*

Qt provides simple **views** for their models. They have a **controller** built in: selecting, editing and moving items are something what in most cases a controller "controls". That is, interpreting user input (mouse clicks and moves) and giving the appropriate commands to the model.

Qt's **models** are indeed models having underlying data. The abstract models of course don't hold data, since Qt doesn't know how you want to store them. But *you* extend a QAbstractItemModel to your needs by adding your data containers to the subclass and making the model interface accessing your data. So in fact, and I assume you don't like this, the problem is that *you* need to program the model, so how data is accessed and modified in your data structure.

In MVC terminology, the model contains both the **data** and the **logic**. In Qt, it's up to you whether or not you include some of your business logic inside your model or put it outside, being a "view" on its own. It's not even clear what's meant by logic: Selecting, renaming and moving items around? => already implemented. Doing calculations with them? => Put it outside or inside the model subclass. Storing or loading data from/to a file? => Put it inside the model subclass.

------

*My personal opinion:*

It is very difficult to provide a good *and* generic MV(C) system to a programmer. Because in most cases the models are simple (e.g. only string lists) Qt also provides a ready-to-use QStringListModel. But if your data is more complex than strings, it's up to you how you want to represent the data via the Qt model/view interface. If you have, for example, a struct with 3 fields (let's say persons with name, age and gender) you could assign the 3 fields to 3 different columns or to 3 different roles. I dislike both approaches.

I think Qt's model/view framework is only useful when you want to display **simple data structures**. It becomes difficult to handle if the data is of **custom types** or structured not in a tree or list (e.g. a graph). In most cases, lists are enough and even in some cases, a model should only hold one single entry. Especially if you want to model one single entry having different attributes (one instance of one class), Qt's model/view framework isn't the right way to separate logic from user interface.

To sum things up, I think Qt's model/view framework is useful if and only if your data is being viewed by one of **Qt's viewer widgets**. It's totally useless if you're about to write your own viewer for a model holding only one entry, e.g. your application's settings, or if your data isn't of printable types.

------

*How did I use Qt model/view within a (bigger) application?*

I once wrote (in a team) an application which uses multiple Qt models to manage data. We decided to create a `DataRole` to hold the actual data which was of a different custom type for each different model subclass. We created an outer model class called `Model` holding all the different Qt models. We also created an outer view class called `View` holding the windows (widgets) which are connected to the models within `Model`. So this approach is an extended Qt MVC, adapted to our own needs. Both `Model` and `View` classes themselves don't have anything to do with the Qt MVC.

Where did we put the **logic**? We created classes which did the actual computations on the data by reading data from source models (when they changed) and writing the results into target models. From Qt's point of view, this logic classes would be views, since they "connect" to models (not "view" for the user, but a "view" for the business logic part of the application).

Where are the **controllers**? In the original MVC terminology, controllers interpret the user input (mouse and keyboard) and give commands to the model to perform the requested action. Since the Qt views already interpret user input like renaming and moving items, this wasn't needed. But what we needed was an interpretation of user interaction which goes beyond the Qt views.



-----------------------------

No, their "model' is definitely not a controller.

The controller is the part of user visible controls that modify the model (and therefore indirectly modify the view). For example, a "delete" button is part of the controller.

I think there is often confusion because many see something like "the controller modifies the model" and think this means the mutating functions on their model, like a "deleteRow()" method. But in classic MVC, the controller is specifically the user interface part. Methods that mutate the model are simply part of the model.

Since MVC was invented, its distinction between controller and view has become increasingly tense. Think about a text box: it both shows you some text and lets you edit it, so is it view or controller? The answer has to be that it is part of both. Back when you were working on a teletype in the 1960s the distinction was clearer – think of the [`ed`](https://en.m.wikipedia.org/wiki/Ed_(text_editor)) – but that doesn't mean things were better for the user back then!

It is true that their QAbstractItemModel is rather higher level than a model would normally be. For example, items in it can have a background colour (a brush technically), which is a decidedly view-ish attribute! So there's an argument that QAbstractItemModel is more like a view and your data is the model. The truth is it's somewhere in between the classic meanings of view and model. But I can't see how it's a controller; if anything that's the QT widget that uses it.
