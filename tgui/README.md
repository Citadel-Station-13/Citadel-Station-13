<<<<<<< HEAD
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [tgui](#tgui)
	- [Concepts](#concepts)
	- [Using It](#using-it)
	- [Copypasta](#copypasta)

<!-- /TOC -->

# tgui
tgui is the user interface library of /tg/station. It is rendered clientside,  based on JSON data sent from the server. Clicks are processed on the server, in  a similar method to native BYOND `Topic()`.

Basic tgui consists of defining a few procs. In these procs you will handle a request to open or update a UI (typically by updating a UI if it exists or setting up and opening it if it does not), a request for data, in which you build a list to be passed as JSON to the UI, and an action handler, which handles any user input. In addition, you will write a HTML template file which renders your data and provides actionable inputs.

tgui is very different from most UIs you will encounter in BYOND programming, and is heavily reliant of Javascript and web technologies as opposed to DM. However, if you are familiar with NanoUI (a library which can be found on almost every other SS13 codebase), tgui should be fairly easy to pick up.

tgui is a fork of NanoUI. The server-side code (DM) is similar and derived from NanoUI, while the clientside is a wholly new project with no code in common.

## Concepts
tgui is loosely based a MVVM architecture. MVVM stands for model, view, view model.
- A model is the object that a UI represents. This is the atom a UI corresponds to in the game world in most cases, and is known as the `src_object` in tgui.
- The view model is how data is represented in terms of the view. In tgui, this is the `ui_data` proc which munges whatever complex data your `src_object` has into a list.
- The view is how the data is rendered. This is the template, a HTML (plus mustaches and other goodies) file which is compiled into the tgui blob that the browser executes.

Not included in the MVVM model are other important concepts:
- The action/topic handler, `ui_act`, is what recieves input from the user and acts on it.
- The request/update proc, `ui_interact` is where you open your UI and set options like title, size, autoupdate, theme, and more.
- Finally, `ui_state`s (set in `ui_interact`) dictate under what conditions a UI may be interacted with. This may be the standard checks that check if you are in range and conscious, or more.

States are easy to write and extend, and what make tgui interactions so powerful. Because states can over overridden from other procs, you can build powerful interactions for embedded objects or remote access.

## Using It
All these examples and abstracts sound great, you might say. But you also might say, "How do I use it?"

Examples can be as simple or as complex as you would like. Let's start with a very basic hello world.

```DM
/obj/machinery/my_machine/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "my_machine", name, 300, 300, master_ui, state)
    ui.open()
```

This is the proc that defines our interface. There's a bit going on here, so let's break it down. First, we override the ui_interact proc on our object. This will be called by `interact` for you, which is in turn called by `attack_hand` (or `attack_self` for items). `ui_interact` is also called to update a UI (hence the `try_update_ui`), so we accept an existing UI to update. The `state` is a default argument so that a caller can overload it with named arguments (`ui_interact(state = overloaded_state)`) if needed.

Inside the `if(!ui)` block (which means we are creating a new UI), we choose our template, title, and size; we can also set various options like `style` (for themes), or autoupdate. These options will be elaborated on later (as will `ui_state`s).

After `ui_interact`, we need to define `ui_data`. This just returns a list of data for our object to use. Let's imagine our object has a few vars:

```DM
/obj/machinery/my_machine/ui_data(mob/user)
  var/list/data = list()
  data["health"] = health
  data["color"] = color

  return data
```

The `ui_data` proc is what people often find the hardest about tgui, but its really quite simple! You just need to represent your object as numbers, strings, and lists, instead of atoms and datums.

Finally, the `ui_act` proc is called by the interface whenever the user used an input. The input's `action` and `params` are passed to the proc.

```DM
/obj/machinery/my_machine/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("change_color")
      var/new_color = params["color"]
      if(!(color in allowed_coors))
        return
      color = new_color
      . = TRUE
  update_icon()
```

The `..()` (parent call) is very important here, as it is how we check that the user is allowed to use this interface (to avoid so-called href exploits). It is also very important to clamp and sanitize all input here. Always assume the user is attempting to exploit the game.

Also note the use of `. = TRUE` (or `FALSE`), which is used to notify the UI that this input caused an update. This is especially important for UIs that do not auto-update, as otherwise the user will never see their change.

Finally, you have a template. This is also a source of confusion for many new users. Some basic HTML knowledge will get you a long way, however.

A template is regular HTML, with mustache for logic and built-in components to quickly build UIs. Here's how we might show some data (components will be elaborated on later).

In a template there are a few special values. `config` is always the same and is part of core tgui (it will be explained later), `data` is the data returned from `ui_data`, and `adata` is the same, but with certain values (numbers at this time) interpolated in order to allow animation.

```html
<ui-display>
  <ui-section label='Health'>
    <span>{{data.health}}</span>
  </ui-section>
  <ui-section label='Color'>
    <span>{{data.color}}</span>
  </ui-section>
</ui-display>
```

Templates can be very confusing at first, as ternary operators, computed properties, and iterators are used quite a bit in more complex interfaces. Start with the basics, and work your way up. Much of the complexity stems from performance concerns. If in doubt, take the simpler approach and refactor if performance becomes an issue.

## Copypasta
We all do it, even the best of us. If you just want to make a tgui **fast**, here's what you need (note that you'll probably be forced to clean your shit up upon code review):

```DM
/obj/copypasta/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state) // Remember to use the appropriate state.
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "copypasta", name, 300, 300, master_ui, state)
    ui.open()

/obj/copypasta/ui_data(mob/user)
  var/list/data = list()
  data["var"] = var

  return data

/obj/copypasta/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("copypasta")
      var/newvar = params["var"]
      var = Clamp(newvar, min_val, max_val) // Just a demo of proper input sanitation.
      . = TRUE
  update_icon() // Not applicable to all objects.
```

And the template:

```html
<ui-display title='My Copypasta Section'>
  <ui-section label='Var'>
    <span>{{data.var}}</span>
  </ui-section>
  <ui-section label='Animated Var'>
    <span>{{adata.var}}</span>
  </ui-section>
</ui-display>
```
=======
# tgui

## Introduction

tgui is a robust user interface framework of /tg/station.

tgui is very different from most UIs you will encounter in BYOND programming.
It is heavily reliant on Javascript and web technologies as opposed to DM.
If you are familiar with NanoUI (a library which can be found on almost
every other SS13 codebase), tgui should be fairly easy to pick up.

## Learn tgui

People come to tgui from different backgrounds and with different
learning styles. Whether you prefer a more theoretical or a practical
approach, we hope you’ll find this section helpful.

### Practical Tutorial

If you are completely new to frontend and prefer to **learn by doing**,
start with our [practical tutorial](docs/tutorial-and-examples.md).

### Guides

This project uses **Inferno** - a very fast UI rendering engine with a similar
API to React. Take your time to read these guides:

- [React guide](https://reactjs.org/docs/hello-world.html)
- [Inferno documentation](https://infernojs.org/docs/guides/components) -
highlights differences with React.

If you were already familiar with an older, Ractive-based tgui, and want
to translate concepts between old and new tgui, read this
[interface conversion guide](docs/converting-old-tgui-interfaces.md).

## Pre-requisites

You will need these programs to start developing in tgui:

- [Node v12.13+](https://nodejs.org/en/download/)
- [Yarn v1.19+](https://yarnpkg.com/en/docs/install)
- [MSys2](https://www.msys2.org/) (optional)

> MSys2 closely replicates a unix-like environment which is necessary for
> the `bin/tgui` script to run. It comes with a robust "mintty" terminal
> emulator which is better than any standard Windows shell, it supports
> "git" out of the box (almost like Git for Windows, but better), has
> a "pacman" package manager, and you can install a text editor like "vim"
> for a full boomer experience.

## Usage

**For MSys2, Git Bash, WSL, Linux or macOS users:**

First and foremost, change your directory to `tgui`.

Run `bin/tgui --install-git-hooks` (optional) to install merge drivers
which will assist you in conflict resolution when rebasing your branches.

Run one of the following:

- `bin/tgui` - build the project in production mode.
- `bin/tgui --dev` - launch a development server.
  - tgui development server provides you with incremental compilation,
  hot module replacement and logging facilities in all running instances
  of tgui. In short, this means that you will instantly see changes in the
  game as you code it. Very useful, highly recommended.
  - In order to use it, you should start the game server first, connect to it
  and wait until the world has been properly loaded and you are no longer
  in the lobby. Start tgui dev server. You'll know that it's hooked correctly
  if data gets dumped to the log when tgui windows are opened.
- `bin/tgui --dev --reload` - reload byond cache once.
- `bin/tgui --dev --debug` - run server with debug logging enabled.
- `bin/tgui --dev --no-hot` - disable hot module replacement (helps when
doing development on IE8).
- `bin/tgui --lint` - show problems with the code.
- `bin/tgui --lint --fix` - auto-fix problems with the code.
- `bin/tgui --analyze` - run a bundle analyzer.
- `bin/tgui --clean` - clean up project repo.
- `bin/tgui [webpack options]` - build the project with custom webpack
options.

**For everyone else:**

If you haven't opened the console already, you can do that by holding
Shift and right clicking on the `tgui` folder, then pressing
either `Open command window here` or `Open PowerShell window here`.

Run `yarn install` to install npm dependencies, then one of the following:

- `yarn run build` - build the project in production mode.
- `yarn run watch` - launch a development server.
- `yarn run lint` - show problems with the code.
- `yarn run lint --fix` - auto-fix problems with the code.
- `yarn run analyze` - run a bundle analyzer.

We also got some batch files in store, for those who don't like fiddling
with the console:

- `bin/tgui-build.bat` - build the project in production mode.
- `bin/tgui-dev-server.bat` - launch a development server.

> Remember to always run a full build before submitting a PR. It creates
> a compressed javascript bundle which is then referenced from DM code.
> We prefer to keep it version controlled, so that people could build the
> game just by using Dream Maker.

## Troubleshooting

**Development server doesn't find my BYOND cache!**

This happens if your Documents folder in Windows has a custom location, for
example in `E:\Libraries\Documents`. Development server has no knowledge
of these non-standard locations, therefore you have to run the dev server
with an additional environmental variable, with a full path to BYOND cache.

```
export BYOND_CACHE="E:/Libraries/Documents/BYOND/cache"
bin/tgui --dev
```

Note that in Windows, you have to go through Advanced System Settings,
System Properties and then open Environment Variables window to do the
same thing. You may need to reboot after this.

## Developer Tools

When developing with `tgui-dev-server`, you will have access to certain
development only features.

**Debug Logs.**
When running server via `bin/tgui --dev --debug`, server will print debug
logs and time spent on rendering. Use this information to optimize your
code, and try to keep re-renders below 16ms.

**Kitchen Sink.**
Press `Ctrl+Alt+=` to open the KitchenSink interface. This interface is a
playground to test various tgui components.

**Layout Debugger.**
Press `Ctrl+Alt+-` to toggle the *layout debugger*. It will show outlines of
all tgui elements, which makes it easy to understand how everything comes
together, and can reveal certain layout bugs which are not normally visible.

## Project Structure

- `/packages` - Each folder here represents a self-contained Node module.
- `/packages/common` - Helper functions
- `/packages/tgui/index.js` - Application entry point.
- `/packages/tgui/components` - Basic UI building blocks.
- `/packages/tgui/interfaces` - Actual in-game interfaces.
Interface takes data via the `state` prop and outputs an html-like stucture,
which you can build using existing UI components.
- `/packages/tgui/layouts` - Root level UI components, that affect the final
look and feel of the browser window. They usually hold various window
elements, like the titlebar and resize handlers, and control the UI theme.
- `/packages/tgui/routes.js` - This is where tgui decides which interface to
pull and render.
- `/packages/tgui/layout.js` - A root-level component, holding the
window elements, like the titlebar, buttons, resize handlers. Calls
`routes.js` to decide which component to render.
- `/packages/tgui/styles/main.scss` - CSS entry point.
- `/packages/tgui/styles/functions.scss` - Useful SASS functions.
Stuff like `lighten`, `darken`, `luminance` are defined here.
- `/packages/tgui/styles/atomic` - Atomic CSS classes.
These are very simple, tiny, reusable CSS classes which you can use and
combine to change appearance of your elements. Keep them small.
- `/packages/tgui/styles/components` - CSS classes which are used
in UI components. These stylesheets closely follow the
[BEM](https://en.bem.info/methodology/) methodology.
- `/packages/tgui/styles/interfaces` - Custom stylesheets for your interfaces.
Add stylesheets here if you really need a fine control over your UI styles.
- `/packages/tgui/styles/layouts` - Layout-related styles.
- `/packages/tgui/styles/themes` - Contains all the various themes you can
use in tgui. Each theme must be registered in `webpack.config.js` file.

## Component Reference

See: [Component Reference](docs/component-reference.md).

## License

All code is licensed with the parent license of *tgstation*, **AGPL-3.0**.

See the main [README](../README.md) for more details.

The Authors retain all copyright to their respective work here submitted.
>>>>>>> 2185124... Merge pull request #50497 from stylemistake/tgui-3.0
