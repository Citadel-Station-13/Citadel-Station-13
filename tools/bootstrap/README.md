# Bootstrap System

## Purpose

This system is responsible for bootstrapping the core scripting languages we use in our build and systems tooling.

- Node
- Python

This will use the versions specified in 'dependencies.sh' at the repository root.

## Usage

`node`, `node.bat`, `node._ps1` will run `node <commands>` where `<commands>` are anything specified after the script, in the context of the `/tools` folder.

`python`, `python.bat`, `python._ps1` will run `python <commands>` where `<commands>` are anything specified after the script, in the context of the `/tools` folder.
