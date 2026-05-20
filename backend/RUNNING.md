# Running the Python Backend

## Steps (Windows / PowerShell)

1. Open a terminal in the backend folder:

   ```powershell
   cd C:\Users\fatma\AI-Dev-Assistant\AI-Dev-Assistant\backend
   ```

2. Copy the env template once and add your API key:

   ```powershell
   Copy-Item .env.example .env
   notepad .env
   ```

   Set `GROQ_API_KEY=...`.

3. Start the backend used by the VS Code extension:

   ```powershell
   .\start_backend.ps1
   ```

   This installs the lightweight extension dependencies from `requirements-extension.txt`.
   Install `requirements.txt` only if you also need the heavier RAG/embedding tooling.

The extension expects the API at:

```text
http://localhost:18000
```

Health check:

```powershell
Invoke-RestMethod http://localhost:18000/health
```

## Manual Startup

Terminal 1:

```powershell
cd C:\Users\fatma\AI-Dev-Assistant\AI-Dev-Assistant\backend
.\.venv\Scripts\Activate.ps1
python -m mcp_tools.server --mode http --port 8001
```

Terminal 2:

```powershell
cd C:\Users\fatma\AI-Dev-Assistant\AI-Dev-Assistant\backend
.\.venv\Scripts\Activate.ps1
python api_server.py --port 18000
```

## Important Note

README, test, explanation, and recommendation features use the Groq-compatible API key through `GROQ_API_KEY`.
MCP/UML features may still use Ollama, so keep Ollama running if you use those routes.
