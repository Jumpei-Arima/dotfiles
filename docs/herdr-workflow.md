# Herdr development workflow

This guide describes the recommended daily workflow for using this repository
with Herdr, Neovim, coding agents, tests, and remote machines.

## Mental model

Use Herdr's hierarchy consistently:

- A **session** is the persistent Herdr server. The default session is enough for
  most work.
- A **workspace** represents one project or Git checkout.
- A **tab** represents one activity, such as editing, an agent, or verification.
- A **pane** runs one long-lived process, such as Neovim, Claude Code, Codex, a
  test watcher, a development server, or logs.

Prefer workspaces over named sessions. Use a named session only when the entire
environment needs separate sockets and runtime state, for example to isolate
work from a personal project.

## Recommended project layout

Start with one workspace for each repository and three tabs:

```text
project workspace
├── edit tab
│   ├── nvim .
│   └── shell
├── agent tab
│   └── claude or codex
└── verify tab
    ├── test watcher or one-shot test command
    └── server or logs
```

This layout keeps editor input, agent conversation, and verification output from
competing for the same terminal history. A small task can use one tab with Neovim
on the left, an agent at the upper right, and tests at the lower right.

Do not let multiple agents edit overlapping files in the same checkout at the
same time. For parallel implementation, create a Git worktree for each agent with
`prefix+shift+g`, or use the CLI:

```sh
herdr worktree create --cwd ~/src/project --branch agent/task-name --label task-name --focus
```

Keep review-only agents in the original checkout when they do not write files.

## First-time agent setup

Herdr detects Claude Code and Codex without extra configuration. Install their
integrations to record native agent session identity so conversations can be
restored more accurately after a Herdr server restart:

```sh
herdr integration install claude
herdr integration install codex
herdr integration status
```

Install only integrations for agents that already have their configuration
directory on the machine. These commands update the agent's local hook files, so
run them separately on each machine where the agent is used.

## Daily local workflow

Start Herdr from the repository:

```sh
cd ~/src/project
herdr
```

When no workspace exists, Herdr creates one. Rename it to the project name with
`prefix+shift+w`. Then build the layout:

1. Start `nvim .` in the first pane.
2. Create an agent tab with `prefix+c`, rename it with `prefix+shift+t`, and run
   `claude` or `codex`.
3. Create a verification tab and run the project's normal test command.
4. Keep a long-running server, test watcher, or log stream in its own pane.
5. Use the sidebar to find agents that are working, done, or blocked on input.

Run tests in the verification tab rather than inside the agent transcript. This
keeps the result visible and makes it easy to rerun after reviewing a change.

## Keys used most often

`prefix` means press `Ctrl-b`, release it, and then press the action key.

| Action | Default key |
| --- | --- |
| Show all active keybindings | `prefix+?` |
| Split right | `prefix+v` |
| Split down | `prefix+minus` (`Ctrl-b`, then `-`) |
| Focus a pane | `prefix+h/j/k/l` |
| Zoom the focused pane | `prefix+z` |
| Close the focused pane | `prefix+x` |
| Create a tab | `prefix+c` |
| Previous or next tab | `prefix+p` / `prefix+n` |
| Open workspace navigation | `prefix+w` |
| Create a workspace | `prefix+shift+n` |
| Detach and leave processes running | `prefix+q` |

Mouse control is also available: click to focus, drag split borders to resize,
and right-click a pane or frame for its context menu.

## Remote workflow on Tesla

The simplest path is to run Herdr on the machine where the code and compute live:

```sh
ssh tesla
cd ~/src/project
herdr
```

Neovim, agents, tests, and logs then run on Tesla. Detach with `Ctrl-b q`, close
the SSH connection, and later reconnect with the same commands. The Herdr server
and pane processes continue running while the client is detached.

When Herdr is installed locally and `tesla` is defined in `~/.ssh/config`, the
same remote session can instead be rendered by the local client:

```sh
herdr --remote tesla
```

Use normal SSH first when debugging authentication. Ghostty remains on the local
Mac; it does not need to be installed on Tesla. Neovim uses OSC 52 clipboard
support in SSH and Mosh sessions when the terminal permits it.

## Detach, stop, and restore

- `Ctrl-b q` detaches the client and leaves every pane running.
- Running `herdr` again attaches to the default session.
- `herdr session list` shows named sessions.
- `herdr server reload-config` reloads settings that can be changed at runtime.
- `herdr server stop` ends the server and its pane processes. Use it only when
  the running work is no longer needed.

Herdr restores layouts after a full server restart. Agent conversation restore
depends on the agent and its installed Herdr integration. A detached live process
does not need restoration because it never stopped.

## Practical habits

- Keep one editing task per workspace or worktree.
- Give tabs short role names such as `edit`, `agent`, `test`, `server`, and `logs`.
- Leave continuous tests and logs visible instead of repeatedly starting them.
- Review `git diff` and run the project test command before accepting agent work.
- Detach for long jobs; stop the server only when intentionally ending them.
- Open `prefix+?` when a key is unclear instead of adding another terminal or
  editor keybinding layer.

See the official Herdr documentation for [concepts](https://herdr.dev/docs/concepts/),
[keyboard controls](https://herdr.dev/docs/keyboard/),
[agent integrations](https://herdr.dev/docs/integrations/), and
[remote persistence](https://herdr.dev/docs/persistence-remote/).
