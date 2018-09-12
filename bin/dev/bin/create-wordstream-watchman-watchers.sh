#!/bin/sh

watchman -j <<-EOT
[
    "trigger", "`pwd`", {
        "name": "python_shared",
        "relative_root": "python_shared",
        "command": ["supervisorctl", "-c", "/Users/t.brown/dev/bin/supervisord.conf", "restart", "all"],
        "append_files": false,
        "expression": [
            "allof",
            ["suffix", "py"],
            ["type", "f"],
            ["not", ["imatch", "flycheck*.py"]],
            ["not", ["iname", "*.#*"]],
            ["not", ["suffix", "pyc"]],
            ["not", ["dirname", "wsframework/src/proto"]]
        ]
    }
]
EOT

watchman -j <<-EOT
[
    "trigger", "`pwd`", {
        "name": "server",
        "relative_root": "server",
        "command": ["supervisorctl", "-c", "/Users/t.brown/dev/bin/supervisord.conf", "restart", "app:engine"],
        "append_files": false,
        "expression": [
            "allof",
            ["suffix", "py"],
            ["type", "f"],
            ["not", ["imatch", "flycheck*.py"]],
            ["not", ["iname", "*.#*"]],
            ["not", ["suffix", "pyc"]],
            ["not", ["dirname", "wsframework/src/proto"]]
        ]
    }
]
EOT

watchman -j <<-EOT
[
    "trigger", "`pwd`", {
        "name": "client",
        "relative_root": "client",
        "command": ["supervisorctl", "-c", "/Users/t.brown/dev/bin/supervisord.conf", "restart", "app:manager"],
        "append_files": false,
        "expression": [
            "allof",
            ["suffix", "py"],
            ["type", "f"],
            ["not", ["imatch", "flycheck*.py"]],
            ["not", ["iname", "*.#*"]],
            ["not", ["suffix", "pyc"]],
            ["not", ["dirname", "wsframework/src/proto"]]
        ]
    }
]
EOT
