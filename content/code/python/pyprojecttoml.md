---
title: "Pyprojecttoml"
date: 2020-03-07T08:53:29+08:00
draft: true
---

```shell
pip install setuptools
```





## PEP 518 和 pyproject.toml

PEP 518的目的是为项目提供一种方法来指定它们所需的构建工具。

就是这样，非常简单明了。在PEP 518和pyproject.toml引入之前。一个项目无法告诉一个像pip这样的工具它需要什么样的构建工具来构建一个wheel(更不用说一个sdist了)。现在setuptools有一个setup_require参数来指定构建项目所需的东西，但是除非你安装了setuptools，否则你无法读取该设置，这意味着你不能声明你需要setuptools来读取setuptools中的设置。这个鸡和蛋的问题就是为什么像virtualenv这样的工具会默认安装setuptools，以及为什么pip在运行一个setup.py时总是会注入setuptools和wheel，不管你是否显式地安装了它。你甚至不要尝试依赖于setuptools的一个特定版本来构建你的项目，因为你没有办法来指定版本; 不管用户碰巧安装了什么，你都得将就使用。

但是PEP 518和pyproject.toml改变了这一点。现在，像pip这样的工具可以读取pyproject.toml，查看其中指定了哪些构建工具，然后将这些工具安装到一个虚拟环境中来构建你的项目。这意味着，如果你愿意，你可以依赖于setuptools和“wheel”的特定版本。另外，如果你需要的话，你甚至可以使用setuptools之外的其他工具来构建(例如flit或Poetry，但是由于这些其他工具需要pyproject.toml，所以他们的用户已经很熟悉pyproject.toml了)。关键是你不再需要对构建你的项目所需的内容进行假设了，这就解放了打包生态系统, 以便其进行实验和发展。

## PEP 517 和造轮子
有了PEP 518，工具就知道需要什么来将一个项目构建成一个轮子(或sdist)。但是，你要怎样从拥有一个pyproject.toml的项目生成一个wheel或sdist呢?这就是PEP 517的用武之地。该PEP指定了如何执行构建工具来构建sdist和wheel。因此，PEP 518安装了构建工具，而PEP 517执行了它们。通过标准化如何运行构建工具，这为使用其他工具打开了大门。在此之前，除了使用python setup.py sdist bdist_wheel之外，没有标准的方法来构建wheel或sdist，这种方法并不是很灵活;例如，运行构建的工具无法传递合适的环境细节。PEP 517帮助我们解决了这个问题。

PEP 517和518导致的另一个变化是构建隔离。既然项目可以指定任意的构建工具，那么像pip这样的工具必须在虚拟环境中构建项目，以确保每个项目的构建工具不会与另一个项目的构建工具需求相冲突。通过确保你的构建工具是一致的，这也有助于可复制的构建。

不幸的是，这会让一些setuptools用户感到沮丧，因为他们没有没有意识到setup.py文件和/或构建环境已经以一种无法被单独构建的方式结构化了。例如,一个用户在离线进行构建，他没有setuptools，他的本地wheels缓存中也没有所需的'wheel'(也称为他们的本地wheel仓库), 因此，当pip试图隔离构建一个项目时会失败，因为pip找不到setuptools和“wheel”来安装到构建的虚拟环境。

## 在pyproject.toml上标准化工具
PEP 518正在尝试引入一个标准文件，该文件所有项目(最终)都应该拥有，这样做的一个有趣的副作用是，非构建开发工具会意识到，它们现在有了一个可以放置自己的配置的文件。我觉得这很有趣，因为最初PEP 518不允许这样做，但是人们选择忽略该PEP的这一部分。我们最终更新了该PEP来允许这个用例，因为很明显人们喜欢将配置数据集中放在一个文件中这一想法。

所以现在像Black、 coverage.py、towncrier和tox (在某种程度上)这样的项目就允许你将它们的配置定义在pyproject.toml中，而不是定义在一个单独的文件中。有时候，你确实会听到人们抱怨说，由于pyproject.toml的原因，他们正在向项目中添加另一个配置文件。但是，我认为人们没有意识到的是，这些项目也可以创建自己的配置文件(事实上，coverage.py和tox都支持自己的文件)。因此，多亏了围绕pyproject.toml的整合项目，确实有一个观点认为，pyproject.toml使得配置文件比以前少了。

## 如何通过setuptools使用pyproject. toml
希望我已经说服你去将pyproject.toml引入到你的基于setuptools的项目中，这样你就可以获得一些好处，比如构建隔离以及指定你希望依赖的setuptools版本的能力。现在你可能在想你的pyproject.toml应该包括什么？不幸的是，没有人有时间去为setuptools文档化所有这些，但幸运的是，问题跟踪添加了该文档，其中概述了什么是必要的:

```toml
[build-system]
requires = ["setuptools >=40.6.0", "wheel"]
build-backend ="setuptools.build_meta"
```

使用了它，你就参与到PEP517标准世界中来了!正如我所说的，你现在可以依赖一个特定版本的setuptools, 并自也可以进行隔离构建（这就是为什么当前目录没有被自动地放置在sys.path上的原因；如果你正在导入本地文件，你将需要 `sys.path.insert(0, os.path.dirname(__file__))` 或等效的方法）。

但是，如果你为setuptools使用了一个带有setup.cfg配置的pyproject.toml，就会有一个好处:你就不需要setup.py文件了!因为像pip这样的工具将会使用PEP 517 API而不是setup.py来调用setuptools，这意味着你就可以删除这个setup.py文件了!

不幸的是，抛弃这个setup.py文件的话会有一个问题：如果你想进行可编辑安装，你仍然需要一个setup.py硬垫片（shim）。但是这对于任何不是setuptools的构建工具来说都是如此，因为还没有一个可编辑安装的标准(不过，人们已经讨论过将其标准化并已经将该标准草拟出来了，但是还没有人有时间来实现概念验证并形成最终的PEP)。幸运的是，这个保持可编辑安装的硬垫片非常小:



一个用于与pyproject.toml和setup.cfg一起使用的setup.py硬垫片（shim）

```python
#!/usr/bin/env python
import setuptools

if __name__ == "__main__":
    setuptools.setup()
```

> 如果你想的话，你甚至可以将这个脚本简化为 `import setuptools; setuptools.setup()`。

## 这一切将如何发展

所有这些归结起来就是Python打包生态系统正朝着以标准为基础的方向努力。这些标准都致力于使工具以及如何使用它们标准化。例如，如果我们都知道wheel是如何被格式化的以及如何安装它们，那么你就不必关心wheel是如何创建的，你只需要知道wheel是为你想要安装的东西而存在的，并且它遵循适当的标准。如果你不断地推进这一工作并进行更多的标准化，那么这将使工具能更容易地通过标准进行通信，并为人们提供使用任何他们想要用来生成这些构件的软件的自由。



例如，你可能已经注意到我一直在说“像pip这样的工具”，而不是仅仅说“pip”。我这样说完全是故意的。通过制定所有这些标准，这意味着工具就不必完全依赖于pip来做事情了，因为“pip就是这样做的”。例如，tox可以通过使用像pep517这样的库来构建一个wheel，然后使用另一个像distlib这样的库来安装这个wheel的方式来自行安装一个wheel。

标准还去除了对某事是否是故意的猜测。这对于确保每个人都同意事情应该如何进行非常重要。当标准开始在彼此之上建立，并很好地流入彼此时，一致性也就会有了。当每个人都朝着他们之前达成一致的相同的东西前进时，争论也就少了(最终)。



它还可以减轻setuptools的压力。它不必尝试成为每个人的一切，因为人们现在可以选择最适合他们的项目和开发风格的工具。对pip来说，也是如此。



另外，我们不是都想用platypus吗?



英文原文：https://snarky.ca/what-the-heck-is-pyproject-toml/