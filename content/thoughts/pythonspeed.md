---
title: "Python Speed"
date: 2021-11-30T11:07:27+08:00
draft: false
tags: 
    - "Thoughts"
categories :                             
    - "Python"
    - "Thoughts"
keywords :                                 
    - "python"
    - "thoughts"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "是什么阻止了Ruby和Python获得Javascript V8那样的速度？" # Lead text
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

[What blocks Ruby, Python to get Javascript V8 speed?](https://stackoverflow.com/questions/5168718/what-blocks-ruby-python-to-get-javascript-v8-speed)


What blocks Ruby, Python to get Javascript V8 speed? 

Are there any Ruby / Python features that are blocking implementation of optimizations (e.g. inline caching) V8 engine has?

Python is co-developed by Google guys so it shouldn't be blocked by software patents.

Or this is rather matter of resources put into the V8 project by Google.

---

Nothing.

Well, okay: money. (And time, people, resources, but if you have money, you can buy those.)

V8 has a team of brilliant, highly-specialized, highly-experienced (and thus highly-paid) engineers working on it, that have decades of experience (I'm talking individually – collectively it's more like centuries) in creating high-performance execution engines for dynamic OO languages. They are basically the same people who also created the Sun HotSpot JVM (among many others).

Lars Bak, the lead developer, has been literally working on VMs for 25 years (and all of those VMs have lead up to V8), which is basically his entire (professional) life. Some of the people writing Ruby VMs aren't even 25 years old.

---

A good part of it has to do with community. Python and Ruby for the most part have no corporate backing. No one gets paid to work on Python and Ruby full-time (and they especially don't get paid to work on CPython or MRI the whole time). V8, on the other hand, is backed by the most powerful IT company in the world.

Furthermore, V8 can be faster because the only thing that matters to the V8 people is the interpreter -- they have no standard library to work on, no concerns about language design. They just write the interpreter. That's it.

It has nothing to do with intellectual property law. Nor is Python co-developed by Google guys (its creator works there along with a few other committers, but they don't get paid to work on Python).

Another obstacle to Python speed is Python 3. Its adoption seems to be the main concern of the language developers -- to the point that they have frozen development of new language features until other implementations catch up.

On to the technical details, I don't know much about Ruby, but Python has a number of places where optimizations could be used (and Unladen Swallow, a Google project, started to implement these before biting the dust). Here are some of the optimizations that they planned. I could see Python gaining V8 speed in the future if a JIT a la PyPy gets implemented for CPython, but that does not seem likely for the coming years (the focus right now is Python 3 adoption, not a JIT).

Many also feel that Ruby and Python could benefit immensely from removing their respective global interpreter locks.

You also have to understand that Python and Ruby are both much heavier languages than JS -- they provide far more in the way of standard library, language features, and structure. The class system of object-orientation alone adds a great deal of weight (in a good way, I think). I almost think of Javascript as a language designed to be embedded, like Lua (and in many ways, they are similar). Ruby and Python have a much richer set of features, and that expressiveness is usually going to come at the cost of speed.

---

The statement is not exactly true
Just like V8 is just an implementation for JS, CPython is just one implementation for Python. Pypy has performances matching V8's.

Also, there the problem of perceived performance : since V8 is natively non blocking, Web dev leads to more performant projects because you save the IO wait. And V8 is mainly used for dev Web where IO is key, so they compare it to similar projects. But you can use Python in many, many other areas than web dev. And you can even use C extensions for a lot of tasks, such as scientific computations or encryption, and crunch data with blazing perfs.

But on the web, most popular Python and Ruby projects are blocking. Python, especially, has the legacy of the synchronous WSGI standard, and frameworks like the famous Django are based on it.

You can write asynchronous Python (like with Twisted, Tornado, gevent or asyncio) or Ruby. But it's not done often. The best tools are still blocking.

However, they are some reasons for why the default implementations in Ruby and Python are not as speedy as V8.

## Experience

Like Jörg W Mittag pointed out, the guys working on V8 are VM geniuses. Python is dev by a bunch a passionate people, very good in a lot of domains, but are not as specialized in VM tuning.

## Resources

The Python Software foundation has very little money : [less than 40k](http://pyfound.blogspot.fr/2012/01/psf-grants-over-37000-to-python.html) in a year to invest in Python. This is kinda crazy when you think big players such as Google, Facebook or Apple are all using Python, but it's the ugly truth : most work is done for free. The language that powers Youtube and existed before Java has been handcrafted by volunteers.

They are smart and dedicated volunteers, but when they identify they need more juice in a field, they can't ask for 300k to hire a top notch specialist for this area of expertise. They have to look around for somebody who would do it for free.

While this works, it means you have to be very a careful about your priorities. Hence, now we need to look at :

## Objectives

Even with the latest modern features, writing Javascript is terrible. You have scoping issues, very few collections, terrible string and array manipulation, almost no stdlist apart from date, maths and regexes, and no syntactic sugar even for very common operations.

But in V8, you've got speed.

This is because, speed was the main objective for Google, since it's a bottleneck for page rendering in Chrome.

In Python, usability is the main objective. Because it's almost never the bottleneck on the project. The scarce resource here is developer time. It's optimized for the developer.
