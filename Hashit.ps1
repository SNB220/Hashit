function Get-TextHash {
    param (
        [string]$Text,
        [string]$Algorithm
    )
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm)
    $hashBytes = $hasher.ComputeHash($bytes)
    return [BitConverter]::ToString($hashBytes).Replace('-', '').ToLower()
}

function Select-Algorithm {
    param ([string]$PromptText = "Choose an algorithm:")
    $algorithms = @("SHA256", "SHA512", "MD5", "SHA1", "SHA384")
    
    Write-Host "`n$PromptText" -ForegroundColor Cyan
    for ($i = 0; $i -lt $algorithms.Count; $i++) {
        Write-Host " [$($i + 1)] $($algorithms[$i])"
    }

    while ($true) {
        $choice = Read-Host "Enter number (1-$($algorithms.Count))"
        if ($choice -match '^[1-5]$') {
            return $algorithms[[int]$choice - 1]
        }
        Write-Host "Invalid selection. Please choose 1 to $($algorithms.Count)." -ForegroundColor Yellow
    }
}

# --- Step 1: Select Algorithm and Input Text 1 ---
Clear-Host
Write-Host "=========================================" -ForegroundColor DarkCyan
Write-Host "     INTERACTIVE POWERSHELL HASHER      " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor DarkCyan

$algo1 = Select-Algorithm -PromptText "Select algorithm for Text 1:"
$text1 = Read-Host "`nEnter Text 1"
$hash1 = Get-TextHash -Text $text1 -Algorithm $algo1

Write-Host "`n---------------- Result -----------------" -ForegroundColor Green
Write-Host "Algorithm : $algo1" -ForegroundColor Yellow
Write-Host "Text 1    : $text1"
Write-Host "Hash 1    : $hash1" -ForegroundColor Green
Write-Host "-----------------------------------------" -ForegroundColor Green

# --- Step 2: Next Action (Compare or Exit) ---
Write-Host "`nWhat would you like to do next?" -ForegroundColor Cyan
Write-Host " [1] Compare with another text"
Write-Host " [2] Exit"

$action = Read-Host "Choose option (1 or 2)"
if ($action -ne "1") {
    Write-Host "`nExiting. Have a great day!" -ForegroundColor DarkGray
    exit
}

# --- Step 3: Text 2 and Algorithm Decision ---
$text2 = Read-Host "`nEnter Text 2"

Write-Host "`nAlgorithm for Text 2:" -ForegroundColor Cyan
Write-Host " [1] Keep same algorithm ($algo1)"
Write-Host " [2] Choose a different algorithm"

$algoChoice = Read-Host "Choose option (1 or 2)"
if ($algoChoice -eq "2") {
    $algo2 = Select-Algorithm -PromptText "Select algorithm for Text 2:"
} else {
    $algo2 = $algo1
}

$hash2 = Get-TextHash -Text $text2 -Algorithm $algo2

# --- Step 4: Comparison & Interactive Summary ---
Write-Host "`n=========================================" -ForegroundColor DarkCyan
Write-Host "           COMPARISON RESULTS            " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor DarkCyan

Write-Host "Item 1:" -ForegroundColor Yellow
Write-Host "  Text      : $text1"
Write-Host "  Algorithm : $algo1"
Write-Host "  Hash      : $hash1"

Write-Host "`nItem 2:" -ForegroundColor Yellow
Write-Host "  Text      : $text2"
Write-Host "  Algorithm : $algo2"
Write-Host "  Hash      : $hash2"

Write-Host "`nAnalysis:" -ForegroundColor Yellow
if ($algo1 -ne $algo2) {
    Write-Host "  Algorithm Status : DIFFERENT ($algo1 vs $algo2)" -ForegroundColor Magenta
    Write-Host "  Hash Match       : NO MATCH (Different algorithms always produce distinct hash formats/lengths)" -ForegroundColor Red
} else {
    Write-Host "  Algorithm Status : IDENTICAL ($algo1)" -ForegroundColor DarkGreen
    if ($hash1 -eq $hash2) {
        Write-Host "  Hash Match       : PERFECT MATCH! Both hashes are identical." -ForegroundColor Green
    } else {
        Write-Host "  Hash Match       : MISMATCH! The text inputs produce different hashes." -ForegroundColor Red
    }
}
Write-Host "=========================================`n" -ForegroundColor DarkCyan