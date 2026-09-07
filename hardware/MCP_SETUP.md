# KiCad MCP connection

Installed on this Mac on 2026-09-05 from
[mixelpixx/KiCAD-MCP-Server](https://github.com/mixelpixx/KiCAD-MCP-Server),
commit `aa53d52c2e37a13cb3574a6e0acf2c728b4d6bfb` (server version 2.7.0).

The installation is at `~/.codex/mcp-servers/kicad`. The `kicad` STDIO server
is enabled in `~/.codex/config.toml`. It uses the installed Node 25.5.0 and
an isolated environment built with KiCad 10.0.6's bundled Python 3.9. It
does not require an API key. Existing Codex settings were preserved; a
private config backup is stored inside the installation directory.

Compatible Node dependency updates were applied, the server was built, and
development dependencies were pruned. The resulting runtime audit reported
zero known vulnerabilities at installation. The source lockfile records
those changes; `requirements-codex.lock.txt` records additional Python
package versions. No KiCad application files were modified.

## Enable in the desktop session

In Codex, open **Settings → MCP servers** and restart the **kicad** server.
If it does not appear yet, reopen Codex to load the updated configuration.
The current conversation's tool inventory may need to refresh after restart.
Computer-use tools cannot operate Codex's own settings window.

## How schematic editing works

This server edits `.kicad_sch` files. The tested backend reports `swig`,
with live GUI synchronization disabled. Save any work in the KiCad editor
before asking for external edits, and reopen the schematic afterward to
see changes. This setup has not established live PCB IPC synchronization.

## Verified operations

- MCP initialization and discovery: server 2.7.0, 229 tools.
- Read the imported schematic: 29 physical components plus 22 power symbols
  and one drawing-frame symbol.
- Add and remove a temporary property on a disposable copy: final file
  byte-for-byte identical to the original; KiCad netlist export passed.
- Edit passive pin types in the project library and refresh the schematic
  cache through MCP. KiCad ERC and netlist export passed, with the remaining
  circuit findings documented in `README.md`.

For sessions whose native MCP inventory has not refreshed yet, the local
installation includes `mcp-local-client.mjs`, a small STDIO SDK client used
for these checks. It accepts newline-delimited tool calls on standard input.
Its logs and discovery inventory are written under `/tmp`.
