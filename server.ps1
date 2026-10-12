# ============================================================
#  PV Generator - local server (PowerShell, no Python required)
#  Serves the app folder at http://localhost:8000 so features that
#  need it (e.g. automatic amount reading from payment screenshots)
#  work. Everything stays on this computer - no internet is used.
#
#  Uses only PowerShell + .NET, which are already built into every
#  Windows PC, so nothing needs to be installed.
# ============================================================

$ErrorActionPreference = 'Stop'

try {
    $root = Split-Path -Parent $MyInvocation.MyCommand.Path
    Set-Location $root
    $port   = 8000
    $prefix = "http://localhost:$port/"

    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()

    Write-Host "============================================================"
    Write-Host " PV Generator is running at $prefix"
    Write-Host " Serving files from: $root"
    Write-Host ""
    Write-Host " Keep this window open while you use the app."
    Write-Host " Close this window (or press Ctrl+C) to stop the server."
    Write-Host "============================================================"
    Write-Host ""

    Start-Process ($prefix + "index.html")

    $mime = @{
        '.html' = 'text/html'
        '.htm'  = 'text/html'
        '.js'   = 'application/javascript'
        '.json' = 'application/json'
        '.css'  = 'text/css'
        '.wasm' = 'application/wasm'
        '.gz'   = 'application/gzip'
        '.png'  = 'image/png'
        '.jpg'  = 'image/jpeg'
        '.jpeg' = 'image/jpeg'
        '.svg'  = 'image/svg+xml'
        '.ico'  = 'image/x-icon'
        '.txt'  = 'text/plain'
    }
    $rootFull = (Resolve-Path $root).Path

    while ($listener.IsListening) {
        $context  = $listener.GetContext()
        $request  = $context.Request
        $response = $context.Response
        try {
            $localPath = [System.Uri]::UnescapeDataString($request.Url.LocalPath)
            if ($localPath -eq '/') { $localPath = '/index.html' }
            $sep = [string][System.IO.Path]::DirectorySeparatorChar
            $relative = $localPath.TrimStart('/') -replace '/', $sep
            $filePath = Join-Path $root $relative

            # keep requests confined to the app folder
            $resolves = $false
            if (Test-Path $filePath -PathType Leaf) {
                $fullPath = (Resolve-Path $filePath).Path
                if ($fullPath.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) { $resolves = $true }
            }

            if ($resolves) {
                $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
                $contentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
                $bytes = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentType   = $contentType
                $response.ContentLength64 = $bytes.Length
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            } else {
                $response.StatusCode = 404
                $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $localPath")
                $response.OutputStream.Write($msg, 0, $msg.Length)
            }
        } catch {
            Write-Host "Request error: $_"
        } finally {
            $response.OutputStream.Close()
        }
    }
}
catch {
    Write-Host ""
    Write-Host "-------------------------------------------------------------"
    Write-Host " PV Generator server failed to start."
    Write-Host ""
    Write-Host " Error details:"
    Write-Host " $_"
    Write-Host ""
    Write-Host " Common causes:"
    Write-Host " - Port 8000 is already in use by another program."
    Write-Host " - This PC's security policy blocks local servers."
    Write-Host ""
    Write-Host " You can still use the app without this server by double-"
    Write-Host " clicking index.html directly - everything works except"
    Write-Host " automatic amount reading from payment screenshots."
    Write-Host "-------------------------------------------------------------"
    Write-Host ""
    Read-Host "Press Enter to close this window"
}
