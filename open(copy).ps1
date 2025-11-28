# Master Opener! 
# All filepaths and personal information has been removed and you'll need to:
# configure Task-Schedulers if using admin.
# configure environmental variables if you want to use this from anywhere in your terminal, and use it with a simple 'open something' command
# rename file to open.ps1

param ( [string]$app )

switch ($app.ToLower()) {

# ------------------------- Single Program Opener --------------------------
# once you configure the file properly, you can just type: "open 'program'" in your terminal.

"program" {Start-Process "insert path"} #normal program

"word" {Start-Process "winword"} #some programs have shortcuts, no need for full path

"user-specific program" {Start-ScheduledTask -TaskName "OpenProgram"} #example for taskscheduling

"ise" {Start-Process "powershell_ise.exe" -Verb RunAs} #excellent editor for this code, RunAs admin


# ------------------------ Suites: hosting multiple programs at once -----------------------
# same logic, just type in your terminal "open course1-suite"

"course1-suite" {

        Write-Host "Starting CourseName suite" -ForegroundColor Cyan
        Start-Process "chrome.exe" -ArgumentList "website link"
        Start-Sleep -Seconds 1 
        # giving a bit of time so you don't overwhelm the processor, causing files to be unopened, particularly for bigger programs
        Start-Process "winword" -ArgumentList "path to word"
        Start-Sleep -Seconds 1
        Start-Process "notepad" -ArgumentList "path to text file"
        Write-Host "Success!" -ForegroundColor Green
}

"course2-suite" {

        Write-Host "Course Menu:" -ForegroundColor Cyan
        Write-Host "1) Exercise 1" -ForegroundColor Yellow
        Write-Host "2) Exercise 2" -ForegroundColor Yellow
        Write-Host "3) Exercise 3" -ForegroundColor Yellow
        Write-Host "4) Notes" -ForegroundColor Yellow
        Write-Host "5) Compose Docker Down" -ForegroundColor DarkRed
        Write-Host "0) Exit"

        $choice = Read-Host "Enter your choice: "

        # ------------------- Docker Problem Function ---------------------
        # if you use Docker in your courses, I recommend keeping this function
        # Docker doesn't always work very well. 

        function Restart-DockerSafely {
            Write-Host "Attempting to safely restart Docker..." -ForegroundColor Cyan

            $dockerProcesses = @("Docker Desktop", "com.docker.backend", "com.docker.build", "vpnkit")

            # Attempt to stop any leftover processes
            foreach ($prcss in $dockerProcesses) {
                try {
                    Get-Process -Name $prcss -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                    Write-Host "Stopped process: $prcss" -ForegroundColor Green
                } catch {
                    Write-Host "Could not stop $prcss (might not be running or access denied)" -ForegroundColor Yellow }
                }

            # Start Docker Desktop, wherever it is
            $dockerPath = "path to docker"

            Write-Host "Starting Docker Desktop..." -ForegroundColor Cyan
            Start-Process $dockerPath
            Start-Sleep -Seconds 7

             # Wait until Docker is responsive
             $timeout = 30 
             $elapsed = 0
             while ($elapsed -lt $timeout) {
            try {
                docker info | Out-Null
                Write-Host "Docker is ready!" -ForegroundColor Green
                return $true
            } catch {
                Start-Sleep -Seconds 5
                $elapsed += 5
                }
            }

            Write-Host "Docker did not start successfully." -ForegroundColor Red
            return $false
            }

        # --------------------------------------------------------------


        function launch_progs {
             Restart-DockerSafely
             Start-Sleep -Seconds 3
             docker compose -f "path to your relevant folder" up -d
             Start-Process "path to a relevant program that runs on Docker, like MySQL Workbench"
        }

        switch ($choice) {
            "1" { 
                Write-Host "You chose exercise $choice" -ForegroundColor Cyan
                launch_progs
                Start-Process "winword" -ArgumentList "path"
                Start-Sleep -Seconds 2
                Start-Process "chrome.exe" -ArgumentList "link"
                Write-Host "Success!" -ForegroundColor Green
            }

            "2" { 
               #etc
            }

            "3" {
                #etc
            }

            "4" {
                #etc
            }

            "5" {
                Write-Host "You're composing down docker! Make sure you've saved everything!" -ForegroundColor DarkRed -BackgroundColor White 
                Write-Host "Are you SURE? y/n: " -ForegroundColor Red -NoNewline
                $yasure = Read-Host
                    if ($yasure -eq "y") {
                        Write-Host "Powering Down (7sec)..."
                        docker compose -f "relevant path" down
                        Start-Sleep -Seconds 5
                        Stop-Process -Name "Docker Desktop" -Force
                        Write-Host "Docker composed down and quit." -ForegroundColor Green
                    } else { Write-Host "Cancelled." 
                    break }
            }

            "0" { break }

            default { Write-Host "Invalid choice!" -ForegroundColor Red }
        }
}


"course3-suite" {

        Write-Host "Testing Course Menu:" -ForegroundColor Cyan
        Write-Host "1) Task 1" -ForegroundColor Yellow
        Write-Host "2) Task 2" -ForegroundColor Yellow
        Write-Host "3) Task 3" -ForegroundColor Yellow
        Write-Host "4) Task 4" -ForegroundColor Yellow
        
        Write-Host "0) Exit"

        $otherchoice = Read-Host "Enter your choice: "

        function open_general_things {
            Write-Host "Opening task $otherchoice"
            Start-Process "chrome.exe" -ArgumentList "link"
        }

        function Open-VSCodeUser {
            param([string]$Folder)
            $Folder | Out-File "location of outfile" -Encoding utf8
            schtasks /run /tn "OpenVSCode-User"
            #this is for an issue when trying to open VSCode from an elevated terminal, needs to use a separate script to open it from a non-elevated terminal, file included
        }


        switch($otherchoice){
        "1" {
           #etc
        }

        "2" {
            open_general_things
            Start-Sleep -Seconds 2
            Start-Process "chrome.exe" -ArgumentList "link"
            Open-VSCodeUser "location to the proper repository"
            Write-Host "Success!" -ForegroundColor Green
        }

        "3" {
            #etc
        }

        "4" {
            #etc 
        }

        "0" { break }

        default { Write-Host "Invalid choice!" -ForegroundColor Red }
        }
}



# ---------------------------- Help and Errors -------------------------------

"help" {
Write-Host "---------------------------------------------------------------"
Write-Host "		Welcome to the Master Opener!" -ForegroundColor Magenta
Write-Host "---------------------------------------------------------------"

Write-Host "Here are your current options. You can open: "
Write-Host "this that other" -ForegroundColor Yellow
Write-Host "---------------------------------------------------------------"
Write-Host "You can also open course suites for your 2025 courses: " 
Write-Host "course1-suite course2-suite course3-suite" -ForegroundColor Yellow
Write-Host "---------------------------------------------------------------"
Write-Host "You may edit your script or view old semester code at 'location'" -ForegroundColor Cyan
Write-Host "Designed by JunFengari - https://github.com/JunFengari" -ForegroundColor Magenta
Write-Host "---------------------------------------------------------------"
}

default { 
Write-Host "App / Suite not found: $app" -ForegroundColor Red
Write-Host "Use 'open help' to see list of available commands" -ForegroundColor Green
}

}

