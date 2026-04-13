# start-services.ps1
$services = @(
    @{name="api-gateway"; port=8092; color="Blue"}
    @{name="auth-service"; port=8093; color="Green"}
    @{name="hotel-service"; port=8094; color="Yellow"}
    @{name="restaurant-service"; port=8095; color="Magenta"}
    @{name="spa-service"; port=8096; color="Cyan"}
    @{name="pilates-service"; port=8097; color="Red"}
    @{name="ai-service"; port=8098; color="Gray"}
    @{Name="promo-service"; Port=8099; Dir=".\promo-service"},          
    @{Name="employee-service"; Port=8100; Dir=".\employee-service"} 
)

Write-Host "Starting all services..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

foreach ($service in $services) {
    Write-Host "Starting $($service.name) on port $($service.port)..." -ForegroundColor $service.color
    Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
        cd '$PSScriptRoot\$($service.name)'
        `$env:DB_HOST='localhost'
        `$env:DB_PORT='5432'
        `$env:DB_USER='postgres'
        `$env:DB_PASSWORD='newpassword123'
        `$env:DB_NAME='imgohotel'
        Write-Host "=== RUNNING $($service.name) ===" -ForegroundColor $($service.color)
        Write-Host "Port: $($service.port)" -ForegroundColor $($service.color)
        Write-Host "Database: imgohotel" -ForegroundColor $($service.color)
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
        Write-Host ""
        go run main.go
"@
    Start-Sleep -Milliseconds 500
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "All services started!" -ForegroundColor Green
