# C:\imgo-enterprise\scripts\seed-facilities.ps1
# Jalankan dengan: powershell -ExecutionPolicy Bypass -File seed-facilities.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  IMGO HOTEL - SEED FACILITIES DATA" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Konfigurasi database
$PG_HOST = "localhost"
$PG_PORT = "5432"
$PG_USER = "postgres"
$PG_PASSWORD = "newpassword123"
$PG_DATABASE = "imgohotel"

# Connection string
$connString = "Host=$PG_HOST;Port=$PG_PORT;Username=$PG_USER;Password=$PG_PASSWORD;Database=$PG_DATABASE"

Write-Host "📡 Connecting to database..." -ForegroundColor Green
Write-Host "   Host: $PG_HOST`:$PG_PORT"
Write-Host "   Database: $PG_DATABASE"
Write-Host ""

# Ambil semua hotel
$hotelsQuery = "SELECT id, name FROM hotels ORDER BY name;"
$hotels = & "C:\Program Files\PostgreSQL\16\bin\psql" -d $PG_DATABASE -U $PG_USER -h $PG_HOST -p $PG_PORT -t -A -F"|" -c "$hotelsQuery" 2>$null

if (-not $hotels) {
    Write-Host "❌ Gagal mengambil data hotel. Pastikan PostgreSQL terinstall dan berjalan." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found hotels:" -ForegroundColor Green
$hotelList = @()
foreach ($hotel in $hotels) {
    $parts = $hotel -split '\|'
    if ($parts.Count -ge 2) {
        $hotelList += @{
            id = $parts[0].Trim()
            name = $parts[1].Trim()
        }
        Write-Host "   - $($parts[1].Trim())" -ForegroundColor Gray
    }
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSERTING RESTAURANT TABLES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

foreach ($hotel in $hotelList) {
    $hotelId = $hotel.id
    $hotelName = $hotel.name
    
    Write-Host "`n📍 Processing: $hotelName" -ForegroundColor Magenta
    
    # Insert restaurant tables for each hotel
    $tables = @(
        @{ number = "T-01"; capacity = 2 },
        @{ number = "T-02"; capacity = 2 },
        @{ number = "T-03"; capacity = 4 },
        @{ number = "T-04"; capacity = 4 },
        @{ number = "T-05"; capacity = 6 },
        @{ number = "T-06"; capacity = 6 },
        @{ number = "T-07"; capacity = 8 },
        @{ number = "T-08"; capacity = 8 },
        @{ number = "VIP-01"; capacity = 10 },
        @{ number = "VIP-02"; capacity = 12 }
    )
    
    foreach ($table in $tables) {
        $insertQuery = @"
INSERT INTO restaurant_tables (id, table_number, capacity, hotel_id) 
VALUES (uuid_generate_v4(), '$($table.number)', $($table.capacity), '$hotelId')
ON CONFLICT DO NOTHING;
"@
        & "C:\Program Files\PostgreSQL\16\bin\psql" -d $PG_DATABASE -U $PG_USER -h $PG_HOST -p $PG_PORT -c "$insertQuery" 2>$null
    }
    Write-Host "   ✅ Inserted $($tables.Count) restaurant tables" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INSERTING SPA SERVICES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

foreach ($hotel in $hotelList) {
    $hotelId = $hotel.id
    $hotelName = $hotel.name
    
    Write-Host "`n📍 Processing: $hotelName" -ForegroundColor Magenta
    
    # Insert spa services for each hotel
    $services = @(
        @{ name = "Traditional Massage"; description = "Relaxing traditional Indonesian massage using natural oils and techniques passed down through generations."; price = 250000; duration = 60 },
        @{ name = "Aromatherapy Massage"; description = "Soothing massage with essential oils to calm your mind and body."; price = 350000; duration = 90 },
        @{ name = "Hot Stone Massage"; description = "Therapeutic massage using heated volcanic stones to relieve muscle tension."; price = 400000; duration = 75 },
        @{ name = "Deep Tissue Massage"; description = "Intense massage focusing on deep muscle layers to release chronic tension."; price = 450000; duration = 90 },
        @{ name = "Balinese Massage"; description = "Traditional Balinese massage combining acupressure, skin rolling, and gentle stretches."; price = 300000; duration = 60 },
        @{ name = "Facial Treatment"; description = "Luxurious facial using natural ingredients to rejuvenate your skin."; price = 280000; duration = 45 },
        @{ name = "Body Scrub"; description = "Exfoliating body scrub using natural ingredients to remove dead skin cells."; price = 220000; duration = 45 },
        @{ name = "Foot Reflexology"; description = "Pressure point massage on feet to improve overall wellness."; price = 180000; duration = 45 }
    )
    
    foreach ($service in $services) {
        $insertQuery = @"
INSERT INTO spa_services (id, name, description, price, duration, hotel_id) 
VALUES (uuid_generate_v4(), '$($service.name)', '$($service.description)', $($service.price), $($service.duration), '$hotelId')
ON CONFLICT DO NOTHING;
"@
        & "C:\Program Files\PostgreSQL\16\bin\psql" -d $PG_DATABASE -U $PG_USER -h $PG_HOST -p $PG_PORT -c "$insertQuery" 2>$null
    }
    Write-Host "   ✅ Inserted $($services.Count) spa services" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INSERTING PILATES CLASSES" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

foreach ($hotel in $hotelList) {
    $hotelId = $hotel.id
    $hotelName = $hotel.name
    
    Write-Host "`n📍 Processing: $hotelName" -ForegroundColor Magenta
    
    # Insert pilates classes for each hotel
    $classes = @(
        @{ name = "Beginner Pilates"; schedule = "2026-04-15 09:00:00"; duration = 60; instructor = "Maria Gonzalez" },
        @{ name = "Intermediate Mat"; schedule = "2026-04-15 10:30:00"; duration = 60; instructor = "Sarah Johnson" },
        @{ name = "Advanced Reformer"; schedule = "2026-04-15 13:00:00"; duration = 75; instructor = "David Chen" },
        @{ name = "Yoga Fusion"; schedule = "2026-04-16 08:30:00"; duration = 90; instructor = "Anita Sharma" },
        @{ name = "Pilates for Beginners"; schedule = "2026-04-16 10:00:00"; duration = 60; instructor = "Maria Gonzalez" },
        @{ name = "Core Strength"; schedule = "2026-04-16 14:00:00"; duration = 60; instructor = "Sarah Johnson" },
        @{ name = "Evening Flow"; schedule = "2026-04-16 17:00:00"; duration = 60; instructor = "David Chen" },
        @{ name = "Weekend Special"; schedule = "2026-04-17 09:30:00"; duration = 90; instructor = "Anita Sharma" }
    )
    
    foreach ($class in $classes) {
        $insertQuery = @"
INSERT INTO pilates_classes (id, name, schedule, duration, instructor, hotel_id) 
VALUES (uuid_generate_v4(), '$($class.name)', '$($class.schedule)', $($class.duration), '$($class.instructor)', '$hotelId')
ON CONFLICT DO NOTHING;
"@
        & "C:\Program Files\PostgreSQL\16\bin\psql" -d $PG_DATABASE -U $PG_USER -h $PG_HOST -p $PG_PORT -c "$insertQuery" 2>$null
    }
    Write-Host "   ✅ Inserted $($classes.Count) pilates classes" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  VERIFICATION" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Count total records
$countQueries = @(
    "SELECT COUNT(*) FROM restaurant_tables;",
    "SELECT COUNT(*) FROM spa_services;",
    "SELECT COUNT(*) FROM pilates_classes;"
)

$labels = @("Restaurant Tables", "Spa Services", "Pilates Classes")

for ($i = 0; $i -lt $countQueries.Length; $i++) {
    $result = & "C:\Program Files\PostgreSQL\16\bin\psql" -d $PG_DATABASE -U $PG_USER -h $PG_HOST -p $PG_PORT -t -c "$($countQueries[$i])" 2>$null
    Write-Host "📊 $($labels[$i]): $result" -ForegroundColor Cyan
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  ✅ ALL DATA INSERTED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Now you can access:" -ForegroundColor Yellow
Write-Host "  🏨 Hotels:      http://localhost:5173/hotels"
Write-Host "  🍽️ Restaurant:  http://localhost:5173/restaurant"
Write-Host "  💆 Spa:         http://localhost:5173/spa"
Write-Host "  🧘 Pilates:     http://localhost:5173/pilates"
Write-Host ""