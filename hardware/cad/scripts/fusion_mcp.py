"""Small stdlib client for the official, local Autodesk Fusion MCP server."""
import argparse
import json
import urllib.request
from pathlib import Path


class Client:
    def __init__(self, url="http://127.0.0.1:27182/mcp", timeout=600):
        self.url, self.session, self.sequence = url, None, 0
        self.timeout = timeout
        self.request("initialize", {"protocolVersion": "2024-11-05", "capabilities": {},
                     "clientInfo": {"name": "trimix-enclosure", "version": "1.0"}})
        self.request("notifications/initialized", {}, notification=True)

    def request(self, method, params, notification=False):
        self.sequence += 1
        payload = {"jsonrpc": "2.0", "method": method, "params": params}
        if not notification:
            payload["id"] = self.sequence
        headers = {"Content-Type": "application/json", "Accept": "application/json, text/event-stream"}
        if self.session:
            headers["Mcp-Session-Id"] = self.session
        req = urllib.request.Request(self.url, json.dumps(payload).encode(), headers)
        with urllib.request.urlopen(req, timeout=self.timeout) as response:
            self.session = response.headers.get("Mcp-Session-Id", self.session)
            if notification:
                return None
            if "text/event-stream" in response.headers.get("Content-Type", ""):
                for line in response:
                    if line.startswith(b"data:"):
                        result = json.loads(line[5:])
                        if result.get("id") == self.sequence:
                            break
                else:
                    raise RuntimeError("MCP stream ended without a matching response")
            else:
                result = json.load(response)
        if "error" in result:
            raise RuntimeError(json.dumps(result["error"]))
        return result.get("result")

    def call(self, name, arguments):
        return self.request("tools/call", {"name": name, "arguments": arguments})


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--list", action="store_true")
    parser.add_argument("--tool")
    parser.add_argument("--arguments", type=Path)
    parser.add_argument("--script", type=Path)
    parser.add_argument("--out", type=Path)
    parser.add_argument("--timeout", type=float, default=600,
                        help="Local MCP response timeout; long CAD checks are polled asynchronously.")
    args = parser.parse_args()
    client = Client(timeout=args.timeout)
    if args.list:
        result = client.request("tools/list", {})
    else:
        if not args.tool:
            parser.error("--tool is required")
        payload = ({"featureType": "script", "object": {"script": args.script.read_text()}}
                   if args.script else json.loads(args.arguments.read_text()))
        result = client.call(args.tool, payload)
    rendered = json.dumps(result, indent=2)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(rendered + "\n")
    print(rendered)
    if isinstance(result, dict) and result.get("isError"):
        raise SystemExit(1)
    for block in result.get('content',[]) if isinstance(result,dict) else []:
        if block.get('type') == 'text':
            try:
                structured=json.loads(block['text'])
            except json.JSONDecodeError:
                continue
            if isinstance(structured,dict) and structured.get('success') is False:
                raise SystemExit(1)


if __name__ == "__main__":
    main()
