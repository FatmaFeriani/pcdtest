param(
  [int]$ApiPort = 18000,
  [int]$McpPort = 8001
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (Test-Path ".\.env") {
  Get-Content ".\.env" | ForEach-Object {
    $line = $_.Trim()
    if (-not $line -or $line.StartsWith("#") -or -not $line.Contains("=")) {
      return
    }
    $key, $value = $line.Split("=", 2)
    if ($key -and -not [Environment]::GetEnvironmentVariable($key, "Process")) {
      [Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim().Trim('"').Trim("'"), "Process")
    }
  }
}

if (-not (Test-Path ".\.venv\Scripts\python.exe")) {
  python -m venv .venv
}

$python = ".\.venv\Scripts\python.exe"
& $python -m pip install -r requirements-extension.txt

$env:MCP_TRANSPORT = "sse"
$env:MCP_URL = "http://localhost:$McpPort"

Write-Host "Starting MCP server on http://localhost:$McpPort ..."
$mcpJob = Start-Job -ScriptBlock {
  param($BackendDir, $PythonExe, $Port)
  Set-Location $BackendDir
  & $PythonExe -m mcp_tools.server --mode http --port $Port
} -ArgumentList $PSScriptRoot, (Resolve-Path $python).Path, $McpPort

try {
  Start-Sleep -Seconds 2
  Write-Host "Starting backend API on http://localhost:$ApiPort ..."
  & $python api_server.py --port $ApiPort
}
finally {
  Stop-Job $mcpJob -ErrorAction SilentlyContinue
  Remove-Job $mcpJob -Force -ErrorAction SilentlyContinue
}
