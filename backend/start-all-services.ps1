# C:\imgo-enterprise\backend\start-all-services.ps1
# Jalankan dengan: powershell -ExecutionPolicy Bypass -File start-all-services.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  IMGO HOTEL - STARTING ALL BACKEND SERVICES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Daftar semua service dengan portnya
$services = @(
    @{name="api-gateway"; port=8092; color="Blue"; type="go"},
    @{name="auth-service"; port=8093; color="Green"; type="go"},
    @{name="hotel-service"; port=8094; color="Yellow"; type="go"},
    @{name="restaurant-service"; port=8095; color="Magenta"; type="go"},
    @{name="spa-service"; port=8096; color="Cyan"; type="go"},
    @{name="pilates-service"; port=8097; color="Red"; type="go"},
    @{name="employee-service"; port=8098; color="DarkYellow"; type="go"},
    @{name="promo-service"; port=8099; color="DarkMagenta"; type="go"},
    @{name="ai-service"; port=8100; color="White"; type="node"}
)

$basePath = "C:\imgo-enterprise\backend"

Write-Host "🚀 Starting Backend Services..." -ForegroundColor Green
Write-Host ""

foreach ($service in $services) {
    $servicePath = Join-Path $basePath $service.name
    $serviceName = $service.name
    $port = $service.port
    $color = $service.color
    $type = $service.type
    
    Write-Host "Starting $serviceName on port $port..." -ForegroundColor Magenta
    
    if (Test-Path $servicePath) {
        if ($type -eq "go") {
            Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
                cd '$servicePath';
                Write-Host '========================================' -ForegroundColor $color;
                Write-Host '  $serviceName :$port' -ForegroundColor $color;
                Write-Host '========================================' -ForegroundColor $color;
                go run main.go
"@
        } else {
            Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
                cd '$servicePath';
                Write-Host '========================================' -ForegroundColor $color;
                Write-Host '  $serviceName :$port' -ForegroundColor $color;
                Write-Host '========================================' -ForegroundColor $color;
                npm run dev
"@
        }
        Write-Host "  ✓ $serviceName started" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Folder not found: $servicePath" -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ ALL SERVICES STARTED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services running on ports:" -ForegroundColor Yellow
Write-Host "  🌐 API Gateway:      http://localhost:8092"
Write-Host "  🔐 Auth Service:     http://localhost:8093"
Write-Host "  🏨 Hotel Service:    http://localhost:8094"
Write-Host "  🍽️ Restaurant:       http://localhost:8095"
Write-Host "  💆 Spa Service:      http://localhost:8096"
Write-Host "  🧘 Pilates Service:  http://localhost:8097"
Write-Host "  👔 Employee Service: http://localhost:8098"
Write-Host "  🎁 Promo Service:    http://localhost:8099"
Write-Host "  🤖 AI Service:       http://localhost:8100"
Write-Host ""
Write-Host "Frontend:" -ForegroundColor Yellow
Write-Host "  🖥️  Customer Portal:  http://localhost:5173"
Write-Host ""
Write-Host "To stop all services, close the PowerShell windows or run:" -ForegroundColor Gray
Write-Host "  Get-Process -Name 'main','node' | Stop-Process -Force"
Write-Host ""